//
//  EmptyPlaceholder.swift
//  Rubick
//
//  Created by WuFan on 16/9/10.
//
//

import Foundation

// Protocol
private var ConfigurationKey: Void = ()

private protocol EmptyPlaceholderConfigurable {
    associatedtype HostView: UIView
    var configuration: PlaceholderConfiguration<HostView> { get }
}

private protocol EmptyPlaceholderContainer {
    func reloadPlaceholder(force force: Bool)
}

private typealias EmptyPlaceholderView = EmptyPlaceholderContainer & EmptyPlaceholderConfigurable


extension EmptyPlaceholderConfigurable where Self: NSObjectProtocol {
    var configuration: PlaceholderConfiguration<HostView> {
        if let value = objc_getAssociatedObject(self, &ConfigurationKey) as? PlaceholderConfiguration<HostView> {
            return value
        }
        let value = PlaceholderConfiguration<HostView>(self as! HostView)
        objc_setAssociatedObject(self, &ConfigurationKey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return value
    }
}

extension EmptyPlaceholderContainer where Self: UIView, Self: EmptyPlaceholderConfigurable {
    func reloadPlaceholder(force force: Bool = false) {
        if !configuration.visible || configuration.hasViewsInView || frame.size == .zero {
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
            (.width, .equal),
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
            
            contentView.addConstraint(constraint)
        }
    }
}

//
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

        NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[imageView][titleLabel][descriptionLabel]|",
                options: [.alignAllCenterX],
                metrics: nil,
                views: [
                    "imageView": imageView,
                    "titleLabel": titleLabel,
                    "descriptionLabel": descriptionLabel,
                    "superView": self
                ]
            )
        )
    }
}

public class PlaceholderConfiguration<HostView: UIView> {
    fileprivate var lastSize: CGSize?
    fileprivate var hasViewsInView: Bool = false
    fileprivate lazy var contentView: UIView = UIView()
    fileprivate lazy var placeholderView: PlaceholderView = PlaceholderView()
    
    var makeTitleClosure: ((HostView) -> String?)?
    var makeImageClosure: ((HostView) -> UIImage?)?
    weak var hostView: HostView!
    
    public var visible: Bool = false {
        didSet {
            guard oldValue != visible else {
                return
            }
            
            if let view = hostView as? EmptyPlaceholderContainer {
                view.reloadPlaceholder(force: false)
                LogD("visible")
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


// Override UITableView and UICollectionView
private class TableView: UITableView, EmptyPlaceholderView {
    typealias HostView = UITableView
    
    override var frame: CGRect {
        get { return super.frame }
        set { super.frame = newValue
            reloadPlaceholder()
        }
    }
    
    override var bounds: CGRect {
        get { return super.bounds }
        set { super.bounds = newValue
            reloadPlaceholder()
        }
    }
    
    override func reloadData() {
        super.reloadData()
        
        guard let dataSource = self.dataSource, let delegate = self.delegate else {
            return
        }
        
        configuration.hasViewsInView = false
        let numberOfSections = dataSource.numberOfSections?(in: self) ?? 1
        for section in 0 ..< numberOfSections {
            let numberOfRowsInSection = dataSource.tableView(self, numberOfRowsInSection: section)
            
            if numberOfRowsInSection > 0 {
                configuration.hasViewsInView = true
                break
            }
            
            let viewForHeaderInSection = delegate.tableView?(self, viewForHeaderInSection: section)
            let titleForHeaderInSection = dataSource.tableView?(self, titleForHeaderInSection: section)
            let viewForFooterInSection = delegate.tableView?(self, viewForFooterInSection: section)
            let titleForFooterInSection = dataSource.tableView?(self, titleForFooterInSection: section)
            if viewForHeaderInSection != nil || titleForHeaderInSection != nil || viewForFooterInSection != nil || titleForFooterInSection != nil {
                configuration.hasViewsInView = true
                break
            }
        }
        reloadPlaceholder(force: true)
    }
}

private class CollectionView: UICollectionView, EmptyPlaceholderView {
    typealias HostView = UICollectionView
    
    override var frame: CGRect {
        get { return super.frame }
        set { super.frame = newValue
            reloadPlaceholder()
        }
    }
    override var bounds: CGRect {
        get { return super.bounds }
        set { super.bounds = newValue
            reloadPlaceholder()
        }
    }
    override func reloadData() {
        super.reloadData()
        
        guard let dataSource = self.dataSource, let delegate = self.delegate else {
            return
        }
        
        configuration.hasViewsInView = collectionViewLayout.layoutAttributesForElements(in: frame)?.count ?? 0 > 0
        
        reloadPlaceholder(force: true)
    }
}

// Extension UITableView and UICollection
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

extension InstanceExtension where Base: UICollectionView {
    public var placeholder: PlaceholderConfiguration<UICollectionView> {
        assertMainThread()
        
        if let view = base as? CollectionView {
            return view.configuration
        }
        assert(object_getClass(base) == UICollectionView.self)
        object_setClass(base, CollectionView.self)
        
        return (base as! CollectionView).configuration
    }
}
