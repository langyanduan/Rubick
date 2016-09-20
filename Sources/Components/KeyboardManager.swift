//
//  KeyboardManager.swift
//  Rubick
//
//  Created by wufan on 16/8/19.
//
//

import UIKit

func == (left: KeyboardTransition?, right: KeyboardTransition?) -> Bool {
    guard let left = left, let right = right else {
        return false
    }
    return left.keyboardVisible == right.keyboardVisible &&
        left.frameBegin == right.frameBegin &&
        left.frameEnd == right.frameEnd &&
        left.animationDuration == right.animationDuration &&
        left.animationCurve == right.animationCurve &&
        left.animationOptions == right.animationOptions
}

public struct KeyboardTransition {
    public let keyboardVisible: Bool
    public let frameBegin: CGRect
    public let frameEnd: CGRect
    public let animationDuration: TimeInterval
    public let animationCurve: UIViewAnimationCurve
    public let animationOptions: UIViewAnimationOptions
}

public protocol KeyboardManagerObserver: class {
    func keyboardFrameChanged(_ transition: KeyboardTransition) -> Void
}

public class KeyboardManager {
    var observerContainter: NSMutableSet = NSMutableSet()
    
    private init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardFrameWillChanged(_:)),
                                               name: Notification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
    }
    
    private var transition: KeyboardTransition?
    
    @objc
    private func keyboardFrameWillChanged(_ notification: Notification) -> Void {
        guard let userInfo = notification.userInfo else {
            return
        }
        
        let transition: KeyboardTransition = transitionFrom(userInfo)
        if self.transition == transition {
            return
        }
        self.transition = transition
        for observer in observerContainter {
            if let observer = observer as? KeyboardManagerObserver {
                observer.keyboardFrameChanged(transition)
            }
        }
    }
    
    private func transitionFrom(_ userInfo: [AnyHashable : Any]) -> KeyboardTransition {
        let frameBegin = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        let frameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveValue = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue ?? 0
        let animationCurve = UIViewAnimationCurve(rawValue: animationCurveValue) ?? .linear
//        let animationOptions = UIViewAnimationOptions(curve: animationCurve)
        let animationOptions = UIViewAnimationOptions(rawValue: UInt(animationCurve.rawValue) << 16)
        let keyboardVisible = frameEnd.intersects(UIScreen.main.bounds);
        return KeyboardTransition(keyboardVisible: keyboardVisible,
                                  frameBegin: frameBegin,
                                  frameEnd: frameEnd,
                                  animationDuration: animationDuration,
                                  animationCurve: animationCurve,
                                  animationOptions: animationOptions)
    }
    
    private func searchKeyboardViewIn(_ window: UIWindow?) -> UIView? {
        /*
         iOS 6/7:
         UITextEffectsWindow
         UIPeripheralHostView << keyboard
         
         iOS 8:
         UITextEffectsWindow
         UIInputSetContainerView
         UIInputSetHostView << keyboard
         
         iOS 9/10:
         UIRemoteKeyboardWindow
         UIInputSetContainerView
         UIInputSetHostView << keyboard
         
         */
        guard let window = window else {
            return nil
        }
        for containerView in window.subviews {
            if NSStringFromClass(type(of: containerView)) != "UIInputSetContainerView" {
                continue
            }
            for keyboardView in containerView.subviews {
                if NSStringFromClass(type(of: keyboardView)) == "UIInputSetHostView" {
                    return keyboardView
                }
            }
            break
        }
        return nil
    }
    
    private func isKeyboardWindow(_ window: UIWindow?) -> Bool {
        /*
         iOS 6/7:
         UITextEffectsWindow
         UIPeripheralHostView << keyboard
         
         iOS 8:
         UITextEffectsWindow
         UIInputSetContainerView
         UIInputSetHostView << keyboard
         
         iOS 9/10:
         UIRemoteKeyboardWindow
         UIInputSetContainerView
         UIInputSetHostView << keyboard
         
         */
        
        guard let window = window else {
            return false
        }
        
        // 判断是否是键盘
        if #available(iOS 9, *) {
            if NSStringFromClass(type(of: window)) == "UIRemoteKeyboardWindow" {
                return true
            }
        } else {
            if NSStringFromClass(type(of: window)) == "UITextEffectsWindow" {
                return true
            }
        }
        
        return false
    }
    
    static public let `default` = KeyboardManager()
    
    private struct KeyboardViewStatic {
        static var isKeyboardVisible: Bool!
        static var keyboardFrame: CGRect?
        
        static func load() {
            if let keyboardViewFrame = KeyboardManager.default.keyboardView?.frame {
                KeyboardViewStatic.isKeyboardVisible = UIScreen.main.bounds.intersects(keyboardViewFrame)
                KeyboardViewStatic.keyboardFrame = keyboardViewFrame
            } else {
                KeyboardViewStatic.isKeyboardVisible = false
            }
        }
        static var isLoaded: Bool {
            return isKeyboardVisible != nil
        }
    }
    public var isKeyboardVisible: Bool {
        if let transition = self.transition {
            return transition.keyboardVisible
        } else {
            if !KeyboardViewStatic.isLoaded {
                KeyboardViewStatic.load()
            }
            return KeyboardViewStatic.isKeyboardVisible
        }
    }
    public var keyboardFrame: CGRect? {
        if let transition = self.transition {
            return transition.frameEnd
        } else {
            if !KeyboardViewStatic.isLoaded {
                KeyboardViewStatic.load()
            }
            return KeyboardViewStatic.keyboardFrame
        }
    }
    
    public var keyboardView: UIView? {
        return searchKeyboardViewIn(keyboardWindow)
    }
    
    public var keyboardWindow: UIWindow? {
        for window in UIApplication.shared.windows {
            if isKeyboardWindow(window) {
                return window
            }
        }
        return nil
    }
    
    public func addObserver(_ observer: KeyboardManagerObserver) {
        assert(Thread.isMainThread)
        self.observerContainter.add(observer)
    }
    
    public func removeObserver(_ observer: AnyObject) {
        assert(Thread.isMainThread)
        self.observerContainter.remove(observer)
    }
    
    public func convert(_ rect: CGRect, to view: UIView?) -> CGRect {
        if rect.isNull {
            return rect;
        }
        if rect.isInfinite {
            return rect
        }
        if view is UIWindow {
            return rect
        }
        guard let view = view, let window = view.window else {
            return rect
        }
        // Windows 的 frame 基本都是屏幕的 bounds, 除非特意设置了其他值, 这种情况不考虑
        return window.convert(rect, to: view)
    }
}
