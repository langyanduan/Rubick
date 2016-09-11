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
    static private let toastDuration: TimeInterval = 3
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private init() {
        fatalError("init() has not been implemented")
    }
    
    let textLabel: UILabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = UIColor.white
        $0.backgroundColor = UIColor.clear
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.preferredMaxLayoutWidth = ScreenWidth - Toast.toastMargin.left - Toast.toastMargin.right
    }
    let backgroundView: UIView = UIView().then {
        $0.backgroundColor = UIColor(white: 0, alpha: 0.7)
        $0.layer.cornerRadius = 3
    }
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0, alpha: 0.4)
        layer.cornerRadius = 3
        addSubview(backgroundView)
        addSubview(textLabel)
        
        KeyboardManager.default.addObserver(self)
    }
    
    deinit {
        KeyboardManager.default.removeObserver(self)
    }
    
    public func keyboardFrameChanged(_ transition: KeyboardTransition) {
        UIView.animate(withDuration: transition.animationDuration, delay: 0, options: transition.animationOptions, animations: {
            self.frame.origin.y = (transition.frameEnd.minY - self.intrinsicContentSize.height - Toast.toastMargin.bottom)
            }, completion: nil)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundView.frame = CGRect(x: Toast.backgroundMargin.left,
                                          y: Toast.backgroundMargin.top,
                                          width: bounds.width - Toast.backgroundMargin.left - Toast.backgroundMargin.right,
                                          height: bounds.height - Toast.backgroundMargin.top - Toast.backgroundMargin.bottom)
        textLabel.frame = CGRect(x: Toast.labelMargin.left,
                                     y: Toast.labelMargin.top,
                                     width: textLabel.intrinsicContentSize.width,
                                     height: textLabel.intrinsicContentSize.height)
    }
    
    public override var intrinsicContentSize : CGSize {
        let intrinsicContentSize = textLabel.intrinsicContentSize
        return CGSize(width: Toast.labelMargin.left + intrinsicContentSize.width + Toast.labelMargin.right,
                      height: Toast.labelMargin.top + intrinsicContentSize.height + Toast.labelMargin.bottom)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dismiss()
    }
    
    func show(text: String?) {
        guard let text = text , !text.isEmpty else {
            self.dismiss()
            return
        }
        
        self.textLabel.text = text
        self.invalidateIntrinsicContentSize()
        
        let keyboardManager = KeyboardManager.default
        let intrinsicContentSize = self.intrinsicContentSize
        if keyboardManager.isKeyboardVisible {
            frame = CGRect(x: (ScreenWidth - intrinsicContentSize.width) / 2,
                               y: keyboardManager.keyboardFrame!.minY - intrinsicContentSize.height - Toast.toastMargin.bottom,
                               width: intrinsicContentSize.width,
                               height: intrinsicContentSize.height)
        } else {
            frame = CGRect(x: (ScreenWidth - intrinsicContentSize.width) / 2,
                               y: ScreenHeight - intrinsicContentSize.height - Toast.toastMargin.bottom,
                               width: intrinsicContentSize.width,
                               height: intrinsicContentSize.height)
        }
        self.setNeedsLayout()
        
        UIApplication.shared.delegate?.window??.addSubview(self)
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1
        })
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(dismiss), object: nil)
        self.perform(#selector(dismiss), with: nil, afterDelay: Toast.toastDuration, inModes: [RunLoopMode.commonModes])
    }
    
    func dismiss() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(dismiss), object: nil)
        
        if self.superview == nil {
            return
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
            }, completion: { _ in
                self.removeFromSuperview()
        })
    }
    
    private static let shared = Toast()
    
    static public func show(text: String?) {
        shared.show(text: text)
    }
    static public func dismiss() {
        shared.dismiss()
    }
}
