//
//  PlaceholderConfiguration.swift
//  Rubick
//
//  Created by WuFan on 2016/10/19.
//
//

import Foundation

public class PlaceholderConfiguration<HostView: UIView> {
    var lastSize: CGSize?
    var hasViewsInView: Bool = false
    lazy var contentView: UIView = UIView()
    lazy var placeholderView: PlaceholderView = PlaceholderView()
    
    var makeTitleClosure: ((HostView) -> String?)?
    var makeImageClosure: ((HostView) -> UIImage?)?
    weak var hostView: HostView!
    
    public var visible: Bool = false {
        didSet {
            guard oldValue != visible else {
                return
            }
            
            if let view = hostView as? PlaceholderContainer {
                view.reloadPlaceholder(force: false)
            }
        }
    }
    
    init(_ hostView: HostView) {
        self.hostView = hostView
    }
    
    @discardableResult
    public func makeTitle(_ closure: @escaping (HostView) -> String?) -> Self {
        makeTitleClosure = closure
        return self
    }
    
    @discardableResult
    public func makeTitle(_ closure: @escaping () -> String?) -> Self {
        makeTitleClosure = { _ in closure() }
        return self
    }
    
    @discardableResult
    public func makeImage(_ closure: @escaping (HostView) -> UIImage?) -> Self {
        makeImageClosure = closure
        return self
    }
    
    @discardableResult
    public func makeImage(_ closure: @escaping () -> UIImage?) -> Self {
        makeImageClosure = { _ in closure() }
        return self
    }
    
    @discardableResult
    public func makeVisible(_ flag: Bool) -> Self {
        visible = flag
        return self
    }
    
    func setupPlaceholderView() {
        let title = makeTitleClosure?(hostView)
        let image = makeImageClosure?(hostView)
        
        placeholderView.imageView.image = image
        placeholderView.titleLabel.text = title
        placeholderView.setNeedsLayout()
    }
    
}

