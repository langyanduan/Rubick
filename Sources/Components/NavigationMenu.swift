//
//  NavigationMenu.swift
//  Rubick
//
//  Created by WuFan on 2016/10/10.
//
//

import Foundation

public class NavigationMenu: UIView {
    let items: [String]
    
    let titleLabel = UILabel().then { (label: UILabel) in
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    let titleImage: UIImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public var isActive = false {
        didSet {
            guard isActive != oldValue else {
                return
            }
            
            if isActive {
                show()
            } else {
                dismiss()
            }
        }
    }
    
    public required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    public init(items: [String]) {
        self.items = items
        super.init(frame: .zero)
        
        addGestureRecognizer(UITapGestureRecognizer { [unowned self] _ in
            self.isActive = !self.isActive
        })
        addSubview(titleLabel)
        addSubview(titleImage)
        
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[titleLabel][titleImage]|", options: .alignAllCenterY, metrics: nil, views: ["titleLabel": titleLabel, "titleImage": titleImage])
        NSLayoutConstraint.activate(constraints)
        NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .lessThanOrEqual, toItem: self, attribute: .height, multiplier: 1, constant: 0).isActive = true
        
        titleLabel.text = items.first
    }
    
    func resize() {
        translatesAutoresizingMaskIntoConstraints = false
        setNeedsLayout()
        layoutIfNeeded()
        translatesAutoresizingMaskIntoConstraints = true
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview is UINavigationBar {
            resize()
        }
    }
    
    lazy var coverView: UIView = UIView().then { (view) in
        view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        view.addGestureRecognizer(UITapGestureRecognizer { [unowned self] (_) in
            self.isActive = false
        })
    }
    
    lazy var segment: SegmentedControl = SegmentedControl(titles: self.items).then { (view) in
        view.translatesAutoresizingMaskIntoConstraints = false
        view.selectedHandler = { [unowned self] (index) in
            self.isActive = false
            
            guard index != self.segment.selectedIndex else { return }
            self.titleLabel.text = self.items[index]
            self.resize()
        }
    }
    
    lazy var contentView: UIView = UIView().then { (view: UIView) in
        let views = ["segment": self.segment]
        view.backgroundColor = .white
        view.addSubview(self.segment)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[segment]-10-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=20)-[segment]-(>=20)-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint(item: self.segment, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
    
    public override var tintColor: UIColor! {
        didSet {
            segment.tintColor = tintColor
        }
    }
    
    func show() {
        guard let navigationController = self.ext.viewController as? UINavigationController,
            let viewController = navigationController.visibleViewController else {
            return
        }
        
        coverView.frame = viewController.view.bounds
        coverView.alpha = 0
        viewController.view.addSubview(coverView)
        UIView.animate(withDuration: 0.2) {
            self.coverView.alpha = 1
        }
        
        let height: CGFloat = 54
        let endFrame = CGRect(x: 0, y: 0, width: navigationController.view.bounds.width, height: height)
        
        contentView.frame = CGRect(x: 0, y: -height, width: navigationController.view.bounds.width, height: height)
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
        viewController.view.addSubview(contentView)
        UIView.animate(withDuration: 0.2) {
            self.contentView.frame = endFrame
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.coverView.alpha = 0
            self.contentView.alpha = 0
        }, completion: { _ in
            self.coverView.alpha = 1
            self.coverView.removeFromSuperview()
            
            self.contentView.alpha = 1
            self.contentView.removeFromSuperview()
        })
    }
}
