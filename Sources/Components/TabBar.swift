//
//  TabBar.swift
//  Rubick
//
//  Created by wufan on 16/8/25.
//
//

import UIKit

public class BarItem: NSObject {
    public var title: String?
    public var image: UIImage?
    public var tag: Int = 0
    public var enable: Bool = true
}

public class TabBarItem: BarItem {
    public var badgeValue: String?
    
    public init(title: String) {
        super.init()
        self.title = title
    }
}

public class TabBar: UIView {
    private class ItemView: UILabel {
        
    }
    private var itemViews: [ItemView]?
    private lazy var indicator: UIView = { [unowned self] in
        let view = UIView()
        self.addSubview(view)
        return view
    }()
    
    public var selectedIndex: Int? {
        didSet {
            indicator.hidden = selectedIndex == nil ? true : false
            itemViews?.enumerate().forEach { (index, view) in
                view.highlighted = index == selectedIndex
            }
            
            setNeedsLayout()
            if oldValue != nil {
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
                    self.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    public override var tintColor: UIColor! {
        set {
            super.tintColor = newValue
            
            let selectedTextColor = self.tintColor ?? UIColor.blackColor()
            let textColor = selectedTextColor.rbk_colorWithAlpah(0.8)
            indicator.backgroundColor = newValue
            itemViews?.forEach {
                $0.textColor = textColor
                $0.highlightedTextColor = textColor
            }
        }
        get {
            return super.tintColor
        }
    }
    
    public var barTintColor: UIColor! = nil {
        didSet {
            super.backgroundColor = barTintColor
        }
    }
    
    public var items: [TabBarItem]? {
        didSet {
            let selectedTextColor = self.tintColor ?? UIColor.blackColor()
            let textColor = selectedTextColor.rbk_colorWithAlpah(0.6)
            
            itemViews?.forEach {
                $0.removeFromSuperview()
            }
            
            itemViews = items?.map { item -> ItemView in
                let view = ItemView()
                view.text = item.title
                view.textColor = textColor
                view.highlightedTextColor = selectedTextColor
                view.textAlignment = .Center
                view.font = UIFont.systemFontOfSize(16)
                addSubview(view)
                return view
            }
            
            selectedIndex = items?.count > 0 ? 0 : nil
            setNeedsLayout()
        }
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapView(_:))))
    }
    
    @objc
    func onTapView(tapGesture: UITapGestureRecognizer) {
        let location = tapGesture.locationInView(self)
        
        guard let itemViews = self.itemViews else {
            return
        }
        
        for (index, view) in itemViews.enumerate() {
            if view.frame.contains(location) {
                selectedIndex = index
                break
            }
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let itemViews = self.itemViews, selectedIndex = self.selectedIndex else {
            return
        }
        
        let itemWidth = bounds.width / CGFloat(itemViews.count)
        let itemHeight = bounds.height
        
        itemViews.enumerate().forEach { (index: Int, element: TabBar.ItemView) in
            element.frame = CGRect(x: CGFloat(index) * itemWidth, y: 0, width: itemWidth, height: itemHeight)
        }
        
        indicator.frame = CGRect(x: (selectedIndex.CGFloat + 0.25) * itemWidth, y: itemHeight - 3, width: itemWidth / 2, height: 3)
    }
}
