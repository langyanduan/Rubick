//
//  KeyboardManager.swift
//  Rubick
//
//  Created by wufan on 16/8/19.
//
//

import UIKit

func == (left: KeyboardTransition?, right: KeyboardTransition?) -> Bool {
    guard let left = left, right = right else {
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
    let keyboardVisible: Bool
    let frameBegin: CGRect
    let frameEnd: CGRect
    let animationDuration: NSTimeInterval
    let animationCurve: UIViewAnimationCurve
    let animationOptions: UIViewAnimationOptions
}

public protocol KeyboardManagerObserver: class {
    func keyboardFrameChanged(transition: KeyboardTransition) -> Void
}

public class KeyboardManager {
    var observerContainter: NSMutableSet = NSMutableSet()
    
    private init() {
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(keyboardFrameWillChanged(_:)),
                                                         name: UIKeyboardWillChangeFrameNotification,
                                                         object: nil)
    }
    
    private var transition: KeyboardTransition?
    
    @objc private func keyboardFrameWillChanged(notification: NSNotification) -> Void {
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
    
    private func transitionFrom(userInfo: NSDictionary) -> KeyboardTransition {
        let frameBegin = userInfo[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue()
        let frameEnd = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        let animationCurve = UIViewAnimationCurve(rawValue: (userInfo[UIKeyboardAnimationCurveUserInfoKey]?.integerValue)!)
        let animationOptions = UIViewAnimationOptions(rawValue: UInt(animationCurve!.rawValue) << 16)
        let keyboardVisible = CGRectIntersectsRect(frameEnd!, UIScreen.mainScreen().bounds);
        return KeyboardTransition(keyboardVisible: keyboardVisible,
                                  frameBegin: frameBegin!,
                                  frameEnd: frameEnd!,
                                  animationDuration: animationDuration!,
                                  animationCurve: animationCurve!,
                                  animationOptions: animationOptions)
    }
    
    private func searchKeyboardViewIn(window: UIWindow?) -> UIView? {
        /*
         iOS 6/7:
         UITextEffectsWindow
         UIPeripheralHostView << keyboard
         
         iOS 8:
         UITextEffectsWindow
         UIInputSetContainerView
         UIInputSetHostView << keyboard
         
         iOS 9:
         UIRemoteKeyboardWindow
         UIInputSetContainerView
         UIInputSetHostView << keyboard
         
         */
        guard let window = window else {
            return nil
        }
        if #available(iOS 8, *) {
            for containerView in window.subviews {
                if NSStringFromClass(containerView.dynamicType) != "UIInputSetContainerView" {
                    continue
                }
                for keyboardView in containerView.subviews {
                    if NSStringFromClass(keyboardView.dynamicType) == "UIInputSetHostView" {
                        return keyboardView
                    }
                }
                break
            }
        } else if #available(iOS 7, *) {
            for keyboardView in window.subviews {
                if NSStringFromClass(keyboardView.dynamicType) == "UIPeripheralHostView" {
                    return keyboardView
                }
                break
            }
        }
        return nil
    }
    
    private func isKeyboardWindow(window: UIWindow?) -> Bool {
        /*
         iOS 6/7:
         UITextEffectsWindow
         UIPeripheralHostView << keyboard
         
         iOS 8:
         UITextEffectsWindow
         UIInputSetContainerView
         UIInputSetHostView << keyboard
         
         iOS 9:
         UIRemoteKeyboardWindow
         UIInputSetContainerView
         UIInputSetHostView << keyboard
         
         */
        
        guard let window = window else {
            return false
        }
        
        // 判断是否是键盘
        if #available(iOS 9, *) {
            if NSStringFromClass(window.dynamicType) == "UIRemoteKeyboardWindow" {
                return true
            }
        } else if #available(iOS 7, *) {
            if NSStringFromClass(window.dynamicType) == "UITextEffectsWindow" {
                return true
            }
        }
        
        return false
    }
    
    static public func defaultManager() -> KeyboardManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: KeyboardManager!
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = KeyboardManager()
        }
        return Static.instance
    }
    
    private struct KeyboardViewStatic {
        static var isKeyboardVisible: Bool!
        static var keyboardFrame: CGRect?
        
        static func load() {
            if let keyboardViewFrame = KeyboardManager.defaultManager().keyboardView?.frame {
                KeyboardViewStatic.isKeyboardVisible = CGRectIntersectsRect(UIScreen.mainScreen().bounds, keyboardViewFrame)
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
        for window in UIApplication.sharedApplication().windows {
            if isKeyboardWindow(window) {
                return window
            }
        }
        return nil
    }
    
    public func addObserver(observer: KeyboardManagerObserver) {
        assert(NSThread.isMainThread())
        self.observerContainter.addObject(observer)
    }
    
    public func removeObserver(observer: AnyObject) {
        assert(NSThread.isMainThread())
        self.observerContainter.removeObject(observer)
    }
    
    public func convertRect(rect: CGRect, toView view: UIView?) -> CGRect {
        if CGRectIsNull(rect) {
            return rect;
        }
        if CGRectIsInfinite(rect) {
            return rect
        }
        if view is UIWindow {
            return rect
        }
        guard let view = view, let window = view.window else {
            return rect
        }
        // Windows 的 frame 基本都是屏幕的 bounds, 除非特意设置了其他值, 这种情况不考虑
        return window.convertRect(rect, toView: view)
    }
}
