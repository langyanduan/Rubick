//
//  SegmentedControl.swift
//  Rubick
//
//  Created by wufan on 16/8/25.
//
//

import UIKit

public class SegmentedControl: UIControl {
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var selectedIndex: Int = 0 {
        didSet {
            reloadStyle()
        }
    }
    
    var titles: [String]
    var labels: [UILabel]?
    var dividers: [UIView] = []
    var contentLayer: CALayer!
    var borderLayer: CAShapeLayer!
    
    func reloadStyle() {
        guard let labels = self.labels else {
            return
        }
        
        labels.enumerate().forEach { (index: Int, label: UILabel) in
            if index == selectedIndex {
                label.textColor = UIColor.whiteColor()
                label.backgroundColor = tintColor
            } else {
                label.textColor = tintColor
                label.backgroundColor = UIColor.whiteColor()
            }
        }
    }
    
    public override var tintColor: UIColor! {
        set {
            super.tintColor = newValue
            
            dividers.forEach { $0.backgroundColor = newValue }
            layer.borderColor = newValue.CGColor
            
            reloadStyle()
        }
        get {
            return super.tintColor
        }
    }
    
    public init(titles: [String]) {
        assert(titles.count > 0)
        self.titles = titles
        super.init(frame: CGRectZero)
        setup()
    }
    
    public override var backgroundColor: UIColor? {
        set { }
        get {
            return nil
        }
    }
    
    func setup() {
        super.backgroundColor = UIColor.whiteColor()
        super.tintColor = UIColor.blackColor()
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.blackColor().CGColor
        layer.masksToBounds = true
        
        guard titles.count > 0 else {
            return
        }
        
        labels = titles.map { text -> UILabel in
            let label = UILabel()
            label.text = text
            label.font = UIFont.boldSystemFontOfSize(16)
            label.textColor = UIColor.blackColor()
            label.backgroundColor = UIColor.whiteColor()
            label.textAlignment = .Center
            addSubview(label)
            
            return label
        }
        
        for _ in 0 ..< titles.count - 1 {
            let view = UIView()
            view.backgroundColor = UIColor.blackColor()
            self.addSubview(view)
            dividers.append(view)
        }
        
        selectedIndex = 0
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapView(_:))))
    }
    
    @objc
    func onTapView(tapGesture: UITapGestureRecognizer) {
        guard let labels = self.labels else {
            return
        }
        let location = tapGesture.locationInView(self)
        for (index, label) in labels.enumerate() {
            if label.frame.contains(location) {
                if selectedIndex == index {
                    return
                }
                selectedIndex = index
                sendActionsForControlEvents(.ValueChanged)
                return
            }
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let labels = self.labels where labels.count > 0 else {
            return
        }
        
        let width = CGFloatFromScalePixel(bounds.width / labels.count.CGFloat)
        let height = bounds.height
        let count = Int((bounds.width - width * labels.count.CGFloat) / CGFloatFromPixel(1))
        
        for (index, label) in labels.enumerate() {
            if index < count {
                label.frame = CGRect(x: index.CGFloat * (width + CGFloatFromPixel(1)), y: 0, width: width + CGFloatFromPixel(1), height: height)
            } else {
                label.frame = CGRect(x: index.CGFloat * width + count.CGFloat * CGFloatFromPixel(1), y: 0, width: width, height: height)
            }
            
            if index < dividers.count {
                let view = dividers[index]
                view.frame = CGRect(x: label.frame.maxX, y: 0, width: 1, height: height)
            }
        }
    }
    
}
