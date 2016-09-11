//
//  EmptyPlaceholder.swift
//  Rubick
//
//  Created by WuFan on 16/9/10.
//
//

import Foundation

private var ConfigurationKey: Void = ()

private class TableView: UITableView {
    var configuration: PlaceholderConfiguration<UITableView> {
        if let value = objc_getAssociatedObject(self, &ConfigurationKey) as? PlaceholderConfiguration<UITableView> {
            return value
        }
        let value = PlaceholderConfiguration<UITableView>(self)
        objc_setAssociatedObject(self, &ConfigurationKey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return value
    }
    
    override var frame: CGRect {
        get { return super.frame }
        set {
            super.frame = newValue
            reloadPlaceholder()
        }
    }
    
    override var bounds: CGRect {
        get { return super.bounds }
        set {
            super.bounds = newValue
            reloadPlaceholder()
        }
    }
    
    override func reloadData() {
        super.reloadData()
        
        guard let dataSource = self.dataSource, let delegate = self.delegate else {
            return
        }
        
        configuration.hasViewsInView = true
        let numberOfSections = dataSource.numberOfSections?(in: self) ?? 1
        for section in 0 ..< numberOfSections {
            let numberOfRowsInSection = dataSource.tableView(self, numberOfRowsInSection: section)
            
            if numberOfRowsInSection > 0 {
                configuration.hasViewsInView = false
                break
            }
            
            let headerHeight = delegate.tableView?(self, heightForHeaderInSection: section) ?? self.sectionHeaderHeight
            let footerHeight = delegate.tableView?(self, heightForFooterInSection: section) ?? self.sectionFooterHeight
            
            if self.style == .grouped && (headerHeight < 0 || footerHeight < 0) {
                configuration.hasViewsInView = false
                break
            }
            
            if headerHeight > 1 || footerHeight > 1 {
                configuration.hasViewsInView = false
                break
            }
        }
        
        reloadPlaceholder(force: true)
    }
    
    func reloadPlaceholder(force force: Bool = false) {
        if !configuration.visible || !configuration.hasViewsInView || frame.size == .zero {
            configuration.contentView.removeFromSuperview()
            return
        }
        
        if !force && frame.size == configuration.lastSize {
            return
        }
        
        configuration.lastSize = frame.size
        configuration.setupPlaceholderView()
        
        addSubview(configuration.contentView)
        
        let contentView = configuration.contentView
        let placeholderView = configuration.placeholderView
        contentView.addSubview(placeholderView)
        contentView.frame = bounds
        contentView.removeConstraints(contentView.constraints)
        
        let layoutDescriptions: [(NSLayoutAttribute, NSLayoutRelation)] = [
            (.width, .lessThanOrEqual),
            (.centerX, .equal),
            (.centerY, .equal),
        ]
        
        for (attribute, relate) in layoutDescriptions {
            let constraint = NSLayoutConstraint(
                item: placeholderView,
                attribute: attribute,
                relatedBy: relate,
                toItem: contentView,
                attribute: attribute,
                multiplier: 1,
                constant: 0)
            
//            constraint.isActive = true
            contentView.addConstraint(constraint)
        }
    }
}

private class PlaceholderView: UIView {
    let titleLabel = UILabel().then { label in
        label.textColor = .red
    }
    let descriptionLabel: UILabel = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let views: [String: AnyObject] = [
            "imageView": imageView,
            "titleLabel": titleLabel,
            "descriptionLabel": descriptionLabel,
            "superView": self
        ]
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView][titleLabel][descriptionLabel]|", options: [.alignAllCenterX], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=0)-[imageView]-(>=0)-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=0)-[titleLabel]-(>=0)-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=0)-[descriptionLabel]-(>=0)-|", options: [], metrics: nil, views: views))
    }
}

public class PlaceholderConfiguration<HostView: NSObject> {
    fileprivate var lastSize: CGSize?
    fileprivate var hasViewsInView: Bool = false
    fileprivate lazy var contentView: UIView = UIView()
    fileprivate lazy var placeholderView: PlaceholderView = PlaceholderView()
    
    var makeTitleClosure: ((HostView) -> String?)?
    var makeImageClosure: ((HostView) -> UIImage?)?
    weak var hostView: HostView!
    
    public var visible: Bool = false
    
    init(_ hostView: HostView) {
        self.hostView = hostView
    }
    
    @discardableResult
    public func makeTitle(_ closure: @escaping (HostView) -> String?) -> Self {
        makeTitleClosure = closure
        return self
    }
    
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

extension InstanceExtension where Base: UITableView {
    
    public var placeholder: PlaceholderConfiguration<UITableView> {
        assertMainThread()
        
        if let tv = base as? TableView {
            return tv.configuration
        }
        assert(object_getClass(base) == UITableView.self)
        object_setClass(base, TableView.self)
        
        return (base as! TableView).configuration
    }
}

