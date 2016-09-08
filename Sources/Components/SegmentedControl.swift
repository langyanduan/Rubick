//
//  SegmentedControl.swift
//  Rubick
//
//  Created by wufan on 16/8/25.
//
//

import UIKit

open class SegmentedControl: UIControl {
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open var selectedIndex: Int = 0 {
        didSet {
            reloadStyle()
        }
    }
    
    var titles: [String]
    var labels: [UILabel]?
    var dividers: [UIView] = []
    var contentLayer: CALayer!
    var borderLayer: CAShapeLayer!
    
    fileprivate var backgroundColor_: UIColor? = UIColor.white
    
    func reloadStyle() {
        guard let labels = self.labels else {
            return
        }
        
        labels.enumerated().forEach { (index: Int, label: UILabel) in
            if index == selectedIndex {
                label.textColor = backgroundColor_
                label.backgroundColor = tintColor
            } else {
                label.textColor = tintColor
                label.backgroundColor = backgroundColor_
            }
        }
    }
    
    open override var tintColor: UIColor! {
        set {
            super.tintColor = newValue
            
            dividers.forEach { $0.backgroundColor = newValue }
            layer.borderColor = newValue.cgColor
            
            reloadStyle()
        }
        get {
            return super.tintColor
        }
    }
    
    public init(titles: [String]) {
        assert(titles.count > 0)
        self.titles = titles
        super.init(frame: CGRect.zero)
        setup()
    }
    
    open override var backgroundColor: UIColor? {
        set {
            backgroundColor_ = newValue
        }
        get {
            return backgroundColor_
        }
    }
    
    func setup() {
        super.backgroundColor = backgroundColor_
        super.tintColor = UIColor.black
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        layer.masksToBounds = true
        
        guard titles.count > 0 else {
            return
        }
        
        labels = titles.map { text -> UILabel in
            let label = UILabel()
            label.text = text
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.textColor = UIColor.black
            label.backgroundColor = backgroundColor_
            label.textAlignment = .center
            addSubview(label)
            
            return label
        }
        
        for _ in 0 ..< titles.count - 1 {
            let view = UIView()
            view.backgroundColor = UIColor.black
            self.addSubview(view)
            dividers.append(view)
        }
        
        selectedIndex = 0
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapView(_:))))
    }
    
    @objc
    func onTapView(_ tapGesture: UITapGestureRecognizer) {
        guard let labels = self.labels else {
            return
        }
        let location = tapGesture.location(in: self)
        for (index, label) in labels.enumerated() {
            if label.frame.contains(location) {
                if selectedIndex == index {
                    return
                }
                selectedIndex = index
                sendActions(for: .valueChanged)
                return
            }
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let labels = self.labels , labels.count > 0 else {
            return
        }
        
        let width = CGFloatFromScalePixel(bounds.width / labels.count.CGFloat)
        let height = bounds.height
        let count = Int((bounds.width - width * labels.count.CGFloat) / CGFloatFromPixel(1))
        
        for (index, label) in labels.enumerated() {
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
