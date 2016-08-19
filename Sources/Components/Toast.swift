//
//  Toast.swift
//  Rubick
//
//  Created by wufan on 16/8/19.
//
//

import UIKit

final public class Toast: UIView, KeyboardManagerObserver {
    static private let labelMargin = UIEdgeInsetsMake(5, 8, 5, 8)
    static private let toastMargin = UIEdgeInsetsMake(0, 25, 60, 25)
    static private let backgroundMargin = UIEdgeInsetsMake(1.5, 1.5, 1.5, 1.5)
    static private let toastDuration: NSTimeInterval = 3
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private init() {
        fatalError("init() has not been implemented")
    }
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = UIColor.clearColor()
        label.font = UIFont.systemFontOfSize(14)
        label.preferredMaxLayoutWidth = ScreenWidth - Toast.toastMargin.left - Toast.toastMargin.right
        return label
    }()
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        view.layer.cornerRadius = 3
        return view
    }()
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0, alpha: 0.4)
        layer.cornerRadius = 3
        addSubview(backgroundView)
        addSubview(textLabel)
        
        KeyboardManager.defaultManager().addObserver(self)
    }
    
    deinit {
        KeyboardManager.defaultManager().removeObserver(self)
    }
    
    public func keyboardFrameChanged(transition: KeyboardTransition) {
        UIView.animateWithDuration(transition.animationDuration, delay: 0, options: transition.animationOptions, animations: {
            self.frame.origin.y = (CGRectGetMinY(transition.frameEnd) - self.intrinsicContentSize().height - Toast.toastMargin.bottom)
            }, completion: nil)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundView.frame = CGRectMake(Toast.backgroundMargin.left,
                                          Toast.backgroundMargin.top,
                                          bounds.width - Toast.backgroundMargin.left - Toast.backgroundMargin.right,
                                          bounds.height - Toast.backgroundMargin.top - Toast.backgroundMargin.bottom)
        textLabel.frame = CGRectMake(Toast.labelMargin.left,
                                     Toast.labelMargin.top,
                                     textLabel.intrinsicContentSize().width,
                                     textLabel.intrinsicContentSize().height)
    }
    
    public override func intrinsicContentSize() -> CGSize {
        let intrinsicContentSize = textLabel.intrinsicContentSize()
        return CGSize(width: Toast.labelMargin.left + intrinsicContentSize.width + Toast.labelMargin.right,
                      height: Toast.labelMargin.top + intrinsicContentSize.height + Toast.labelMargin.bottom)
    }
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        dismiss()
    }
    
    func show(text text: String?) {
        guard let text = text where !text.isEmpty else {
            self.dismiss()
            return
        }
        
        self.textLabel.text = text
        self.invalidateIntrinsicContentSize()
        
        let keyboardManager = KeyboardManager.defaultManager()
        let intrinsicContentSize = self.intrinsicContentSize()
        if keyboardManager.isKeyboardVisible {
            frame = CGRectMake((ScreenWidth - intrinsicContentSize.width) / 2,
                               CGRectGetMinY(keyboardManager.keyboardFrame!) - intrinsicContentSize.height - Toast.toastMargin.bottom,
                               intrinsicContentSize.width,
                               intrinsicContentSize.height)
        } else {
            frame = CGRectMake((ScreenWidth - intrinsicContentSize.width) / 2,
                               ScreenHeight - intrinsicContentSize.height - Toast.toastMargin.bottom,
                               intrinsicContentSize.width,
                               intrinsicContentSize.height)
        }
        self.setNeedsLayout()
        
        UIApplication.sharedApplication().delegate?.window??.addSubview(self)
        UIView.animateWithDuration(0.25) {
            self.alpha = 1
        }
        
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(dismiss), object: nil)
        self.performSelector(#selector(dismiss), withObject: nil, afterDelay: Toast.toastDuration, inModes: [NSRunLoopCommonModes])
    }
    
    func dismiss() {
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(dismiss), object: nil)
        
        if self.superview == nil {
            return
        }
        
        UIView.animateWithDuration(0.2, animations: {
            self.alpha = 0
            }, completion: { _ in
                self.removeFromSuperview()
        })
    }
    
    static private func sharedToast() -> Toast {
        struct Static {
            static var instance: Toast!
            static var onceToken: dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = Toast(frame: CGRectZero)
        }
        return Static.instance
    }
    
    static public func show(text text: String?) {
        sharedToast().show(text: text)
    }
    static public func dismiss() {
        sharedToast().dismiss()
    }
}
