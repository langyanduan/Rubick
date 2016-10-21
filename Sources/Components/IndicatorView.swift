//
//  IndicatorView.swift
//  Rubick
//
//  Created by WuFan on 2016/10/12.
//
//

import Foundation
import UIKit

private let animationKey = "contentRotation"

public class IndicatorView: UIView {
    public required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    class ContentView: UIView {
        var count = 0
        var start: CGFloat = 0
        var end: CGFloat = 0.05
        var colorIndex = 0
        var color = UIColorFromRGB(0x3498db)
        let colors: [UIColor] = [
            UIColorFromRGB(0x3498db),
            UIColorFromRGB(0xe74c3c),
            UIColorFromRGB(0xf1c40f),
            UIColorFromRGB(0x2fa841),
        ]
        var displayLink: CADisplayLink?
        
        var isAnimating = false {
            didSet {
                guard oldValue != isAnimating else {
                    return
                }
                
                if isAnimating {
                    count = 0
                    start = 0
                    end = 0.05
                    colorIndex = 0
                    color = colors[0]
                    
                    displayLink = CADisplayLink(target: self, selector: #selector(update))
                    displayLink?.add(to: RunLoop.main, forMode: .commonModes)
                    layer.add(rotationAnimation(), forKey: animationKey)
                } else {
                    displayLink?.invalidate()
                    displayLink = nil
                    layer.removeAllAnimations()
                }
                setNeedsLayout()
            }
        }
        
        @objc
        func update() {
            switch count {
            case 0..<26:
                end += 0.03
            case 33..<59:
                start += 0.03
            case 65:
                colorIndex = (colorIndex + 1) % 4
                color = colors[colorIndex]
            default:
                break
            }
            
            count = (count + 1) % 66
            setNeedsDisplay()
        }
        
        override func draw(_ rect: CGRect) {
            guard isAnimating else { return }
            
            let context = UIGraphicsGetCurrentContext()!
            
            context.setLineWidth(2)
            context.setStrokeColor(color.cgColor)
            context.setLineCap(.butt)
            context.addArc(center: CGPoint(x: 10, y: 10), radius: 8, startAngle: start * CGFloat(M_PI) * 2, endAngle: end * CGFloat(M_PI) * 2, clockwise: false)
            context.strokePath()
        }
        
        override func willMove(toWindow newWindow: UIWindow?) {
            if window == nil && newWindow != nil && isAnimating && layer.animation(forKey: animationKey) == nil {
                layer.add(rotationAnimation(), forKey: animationKey)
            }
        }
        
        func rotationAnimation() -> CABasicAnimation {
            let animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.fromValue = 0 as NSNumber
            animation.toValue = (2 * CGFloat(M_PI)) as NSNumber
            animation.duration = 2
            animation.repeatCount = Float.infinity
            return animation
        }
    }
    
    private let contentView = ContentView().then {
        $0.backgroundColor = .clear
    }
    
    public var isAnimating: Bool { return contentView.isAnimating }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentView)
        activateLayoutConstraints(contentView, self) { (contentView, self) in [
            contentView.centerX == self.centerX,
            contentView.centerY == self.centerY,
            contentView.width == 20,
            contentView.height == 20,
        ]}
    }
    deinit {
        contentView.isAnimating = false
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 20, height: 20)
    }
    public func startAnimating() {
        contentView.isAnimating = true
    }
    public func stopAnimating() {
        contentView.isAnimating = false
    }
}
