//
//  PlaceholderProtocol.swift
//  Rubick
//
//  Created by WuFan on 2016/10/19.
//
//

import Foundation

// Protocol
private var associatedKey = 0

protocol PlaceholderConfigurable {}
protocol PlaceholderContainer {
    func reloadPlaceholder(force: Bool)
}

typealias PlaceholderProtocol = PlaceholderContainer & PlaceholderConfigurable


extension PlaceholderConfigurable where Self: UIView {
    var configuration: PlaceholderConfiguration<Self>? {
        get { return objc_getAssociatedObject(self, &associatedKey) as? PlaceholderConfiguration<Self> }
        set { objc_setAssociatedObject(self, &associatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func configurationIfNeeded() -> PlaceholderConfiguration<Self> {
        if let configuration = self.configuration {
            return configuration
        }
        
        let configuration = PlaceholderConfiguration<Self>(self)
        objc_setAssociatedObject(self, &associatedKey, configuration, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return configuration
    }
}

extension PlaceholderContainer where Self: UIView, Self: PlaceholderConfigurable {
    func reloadPlaceholder(force: Bool) {
        guard let configuration = self.configuration else {
            return
        }
        if !configuration.visible || configuration.hasViewsInView || frame.isEmpty {
            configuration.contentView.removeFromSuperview()
            return
        }
        
        if !force && frame.size == configuration.lastSize {
            return
        }
        
        configuration.lastSize = frame.size
        configuration.setupPlaceholderView()
        
        let contentView = configuration.contentView
        var contentFrame = bounds
        contentFrame.origin = .zero
        contentView.frame = contentFrame
        addSubview(contentView)
        
        let placeholderView = configuration.placeholderView
        contentView.addSubview(placeholderView)
        contentView.removeConstraints(contentView.constraints)
        
        activateLayoutConstraints([
            placeholderView.centerX == contentView.centerX,
            placeholderView.centerY == contentView.centerY,
            placeholderView.width == contentView.width,
        ])
    }
}
