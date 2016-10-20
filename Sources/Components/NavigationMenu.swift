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
    let titleImage: UIView = UIView().then { (view) in
        view.translatesAutoresizingMaskIntoConstraints = false
        activateLayoutConstraints([
            view.width == 20,
            view.height == 8
        ])
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 6, y: 2))
        path.addLine(to: CGPoint(x: 10, y: 6))
        path.addLine(to: CGPoint(x: 14, y: 2))
        let layer = CAShapeLayer()
        layer.path = path
        layer.lineCap = kCALineCapRound
        layer.lineJoin = kCALineJoinMiter
        layer.lineWidth = 2
        layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        view.layer.addSublayer(layer)
    }
    
    public var handler: ((Int, String) -> Void)?
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
            
            UIView.animate(withDuration: 0.2) {
                self.titleImage.transform = self.isActive ? CGAffineTransform.identity.rotated(by: CGFloat(M_PI)) : .identity
            }
        }
    }
    
    public required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    public init(items: [String]) {
        self.items = items
        super.init(frame: CGRect(x: 0, y: 0, width: 160, height: 44))
        
        addGestureRecognizer(UITapGestureRecognizer { [unowned self] _ in
            self.isActive = !self.isActive
        })
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        view.addSubview(titleImage)
        addSubview(view)
        
        activateHorizontalLayout(in: view, options: [.alignCenter(to: view), .heightLessThanOrEqual(to: view)], items: [
            titleLabel, titleImage
        ])
        activateLayoutConstraints([
            view.centerX == self.centerX,
            view.centerY == self.centerY,
        ])
        
        titleLabel.text = items.first
    }
    
    public override var tintColor: UIColor! {
        didSet {
            segment.tintColor = tintColor
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
            self.titleLabel.invalidateIntrinsicContentSize()
            self.handler?(index, self.items[index])
        }
    }
    
    lazy var contentView: UIView = UIView().then { (view: UIView) in
        let views = ["segment": self.segment]
        view.backgroundColor = .white
        view.addSubview(self.segment)
        
        activateVerticalLayout(in: view, options: [.alignCenter(to: view)], items: [
            ==10, self.segment, ==10
        ])
        activateHorizontalLayout(in: view, items: [
            >=20, self.segment, >=20
        ])
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
