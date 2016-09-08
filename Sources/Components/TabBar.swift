//
//  TabBar.swift
//  Rubick
//
//  Created by wufan on 16/8/25.
//
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


open class BarItem: NSObject {
    open var title: String?
    open var image: UIImage?
    open var tag: Int = 0
    open var enable: Bool = true
}

open class TabBarItem: BarItem {
    open var badgeValue: String?
    
    public init(title: String) {
        super.init()
        self.title = title
    }
}

open class TabBar: UIView {
    fileprivate class ItemView: UILabel {
        
    }
    fileprivate var itemViews: [ItemView]?
    fileprivate lazy var indicator: UIView = { [unowned self] in
        let view = UIView()
        self.addSubview(view)
        return view
    }()
    
    open var selectedIndex: Int? {
        didSet {
            indicator.isHidden = selectedIndex == nil ? true : false
            itemViews?.enumerated().forEach { (index, view) in
                view.isHighlighted = index == selectedIndex
            }
            
            setNeedsLayout()
            if oldValue != nil {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
                    self.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    open override var tintColor: UIColor! {
        set {
            super.tintColor = newValue
            
            let selectedTextColor = self.tintColor ?? UIColor.black
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
    
    open var barTintColor: UIColor! = nil {
        didSet {
            super.backgroundColor = barTintColor
        }
    }
    
    open var items: [TabBarItem]? {
        didSet {
            let selectedTextColor = self.tintColor ?? UIColor.black
            let textColor = selectedTextColor.rbk_colorWithAlpah(0.6)
            
            itemViews?.forEach {
                $0.removeFromSuperview()
            }
            
            itemViews = items?.map { item -> ItemView in
                let view = ItemView()
                view.text = item.title
                view.textColor = textColor
                view.highlightedTextColor = selectedTextColor
                view.textAlignment = .center
                view.font = UIFont.systemFont(ofSize: 16)
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
    func onTapView(_ tapGesture: UITapGestureRecognizer) {
        let location = tapGesture.location(in: self)
        
        guard let itemViews = self.itemViews else {
            return
        }
        
        for (index, view) in itemViews.enumerated() {
            if view.frame.contains(location) {
                selectedIndex = index
                break
            }
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let itemViews = self.itemViews, let selectedIndex = self.selectedIndex else {
            return
        }
        
        let itemWidth = bounds.width / CGFloat(itemViews.count)
        let itemHeight = bounds.height
        
        itemViews.enumerated().forEach { (index: Int, element: TabBar.ItemView) in
            element.frame = CGRect(x: CGFloat(index) * itemWidth, y: 0, width: itemWidth, height: itemHeight)
        }
        
        indicator.frame = CGRect(x: (selectedIndex.CGFloat + 0.25) * itemWidth, y: itemHeight - 3, width: itemWidth / 2, height: 3)
    }
}
