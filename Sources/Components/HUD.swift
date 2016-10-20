//
//  HUD.swift
//  Rubick
//
//  Created by WuFan on 2016/10/20.
//
//

import Foundation

public class HUD: UIView {
    public required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public init(containerView: UIView) {
        super.init(frame: .zero)
        self.containerView = containerView
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    weak var containerView: UIView?
    var isContainerInteractiveEnabled: Bool = false
    
    public func show() {
        guard let containerView = containerView else { return }
        
        isContainerInteractiveEnabled = containerView.isUserInteractionEnabled
        containerView.isUserInteractionEnabled = false
        
        frame = containerView.bounds
        containerView.addSubview(self)
        
        alpha = 0
        UIView.animate(withDuration: 0.25) { 
            self.alpha = 1
        }
    }
    
    public func dismiss() {
        guard let containerView = containerView else { return }
        
        containerView.isUserInteractionEnabled = isContainerInteractiveEnabled
        
        alpha = 1
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}
