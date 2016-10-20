//
//  ProgressIndicatorView.swift
//  Rubick
//
//  Created by WuFan on 2016/10/13.
//
//

import Foundation

public class ProgressIndicatorView: UIView {
    class ContentView: UIView {
        let color = UIColorFromRGB(0x3498db)
        var rotation: CGFloat = 0 {
            didSet {
                guard oldValue != rotation && !isAnimating else {
                    return
                }
                transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2) * rotation)
            }
        }
        var progress: CGFloat = 0 {
            didSet {
                if progress < 0 {
                    rotation = 0
                    progress = 0
                } else if progress > 1 {
                    rotation = min(2, progress)
                    progress = 1
                } else {
                    rotation = progress
                }
                guard oldValue != progress else {
                    return
                }
                
                setNeedsDisplay()
            }
        }
        
        var count = 0
        var start: CGFloat = 0
        var end: CGFloat = 0.05
        var colorIndex = 0
        var animationColor = UIColorFromRGB(0x3498db)
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
                    count = 13
                    start = 0
                    end = 0.05 + 13 * 0.06
                    colorIndex = 0
                    animationColor = colors[0]
                    
                    displayLink = CADisplayLink(target: self, selector: #selector(update))
                    displayLink?.add(to: RunLoop.main, forMode: .commonModes)
                    
                    let animation = CABasicAnimation(keyPath: "transform.rotation")
                    animation.fillMode = kCAFillModeBoth
                    animation.fromValue = CGFloat(M_PI_2) * rotation
                    animation.toValue = CGFloat(M_PI_2) * rotation + 2 * CGFloat(M_PI)
                    animation.duration = 2
                    animation.repeatCount = Float.infinity
                    layer.add(animation, forKey: "rotation")
                } else {
                    displayLink?.invalidate()
                    displayLink = nil
                    layer.removeAllAnimations()
                }
                setNeedsLayout()
            }
        }
        
        @objc func update() {
            switch count {
            case 0..<13:
                end += 0.06
            case 18..<31:
                start += 0.06
            case 33:
                colorIndex = (colorIndex + 1) % 4
                animationColor = colors[colorIndex]
            default:
                break
            }
            
            count = (count + 1) % 36
            setNeedsDisplay()
        }
        
        public override func draw(_ rect: CGRect) {
            if isAnimating {
                let context = UIGraphicsGetCurrentContext()!
                context.setLineWidth(2)
                context.setStrokeColor(animationColor.cgColor)
                context.setLineCap(.butt)
                context.addArc(center: CGPoint(x: 15, y: 15), radius: 8, startAngle: start * CGFloat(M_PI) * 2, endAngle: end * CGFloat(M_PI) * 2, clockwise: false)
                context.strokePath()
            } else {
                let progress = self.progress * 0.8
                let context = UIGraphicsGetCurrentContext()!
                let angle = CGFloat(M_PI) * 2 * progress
                let arrowProgress = min(self.progress * 2, 1)
                let arrowLength: CGFloat = 4 * arrowProgress
                let arrowAngle = angle + arrowProgress * 0.4
                
                let cgColor = abs(1 - self.progress) <= CGFloat.leastNormalMagnitude ? color.cgColor : color.withAlphaComponent(0.5).cgColor
                
                context.setLineWidth(2)
                context.setStrokeColor(cgColor)
                context.setLineCap(.butt)
                context.addArc(center: CGPoint(x: 15, y: 15), radius: 8, startAngle: 0, endAngle: angle, clockwise: false)
                context.strokePath()
                
                let path = CGMutablePath()
                path.move(to: CGPoint(x: 15 + cos(angle) * (8 - arrowLength), y: 15 + sin(angle) * (8 - arrowLength)))
                path.addLine(to: CGPoint(x: 15 + cos(angle) * (8 + arrowLength), y: 15 + sin(angle) * (8 + arrowLength)))
                path.addLine(to: CGPoint(x: 15 + cos(arrowAngle) * 8, y: 15 + sin(arrowAngle) * 8))
                path.closeSubpath()
                
                context.addPath(path)
                context.setFillColor(cgColor)
                context.fillPath()
            }
        }
        
        override func willMove(toWindow newWindow: UIWindow?) {
            if window == nil && newWindow != nil && isAnimating && layer.animation(forKey: "rotation") == nil {
                let animation = CABasicAnimation(keyPath: "transform.rotation")
                animation.fromValue = 0
                animation.toValue = 2 * CGFloat(M_PI)
                animation.duration = 2
                animation.repeatCount = Float.infinity
                layer.add(animation, forKey: "rotation")
            }
        }
    }
    
    var contentView = ContentView()
    public var progress: CGFloat {
        get { return contentView.progress }
        set { contentView.progress = newValue }
    }
    
    public func startAnimating() {
        contentView.isAnimating = true
    }
    public func stopAnimation() {
        contentView.isAnimating = false
    }
    
    public required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.frame = CGRect(x: (bounds.width - 30) / 2, y: (bounds.height - 30) / 2, width: 30, height: 30)
        contentView.backgroundColor = .clear
        addSubview(contentView)
        
        activateLayoutConstraints([
            contentView.centerX == self.centerX,
            contentView.centerY == self.centerY,
            contentView.width == 30,
            contentView.height == 30,
        ])
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 30, height: 30)
    }
}
