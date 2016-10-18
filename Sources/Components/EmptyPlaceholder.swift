//
//  EmptyPlaceholder.swift
//  Rubick
//
//  Created by WuFan on 16/9/10.
//
//

import Foundation

// Protocol
private var ConfigurationKey = 0

private protocol EmptyPlaceholderConfigurable {
    associatedtype HostView: UIView
    var configuration: PlaceholderConfiguration<HostView>? { set get }
}

private protocol EmptyPlaceholderContainer {
    func reloadPlaceholder(force: Bool)
}

private typealias EmptyPlaceholderView = EmptyPlaceholderContainer & EmptyPlaceholderConfigurable


extension EmptyPlaceholderConfigurable where Self: NSObjectProtocol {
    var configuration: PlaceholderConfiguration<HostView>? {
        get { return objc_getAssociatedObject(self, &ConfigurationKey) as? PlaceholderConfiguration<HostView> }
        set { objc_setAssociatedObject(self, &ConfigurationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func configurationIfNeeded() -> PlaceholderConfiguration<HostView> {
        if let configuration = self.configuration {
            return configuration
        }
        
        let configuration = PlaceholderConfiguration<HostView>(self as! HostView)
        objc_setAssociatedObject(self, &ConfigurationKey, configuration, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return configuration
    }
    
}

extension EmptyPlaceholderContainer where Self: UIView, Self: EmptyPlaceholderConfigurable {
    func reloadPlaceholder(force: Bool = false) {
        guard let configuration = self.configuration else {
            return
        }
        if !configuration.visible || configuration.hasViewsInView || frame.size == .zero {
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
        label.textColor = UIColor(white: 0.6, alpha: 1)
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

//class ObserverView: UIView {
//    let frameKeyPath = "frame"
//    let boundsKeyPath = "bounds"
//    
//    struct Observer {
//        struct frame {
//            static let keyPath = "frame"
//            static var context = 0
//        }
//        struct bounds {
//            static let keyPath = "bounds"
//            static var context = 0
//        }
//    }
//    
//    override func willMove(toSuperview newSuperview: UIView?) {
//        if let superview = superview as? UIScrollView {
//            superview.removeObserver(self, forKeyPath: Observer.frame.keyPath)
//            superview.removeObserver(self, forKeyPath: Observer.bounds.keyPath)
//        }
//        
//        if let superview = newSuperview as? UIScrollView {
//            superview.addObserver(self, forKeyPath: Observer.frame.keyPath, options: [.new], context: &Observer.frame.context)
//            superview.addObserver(self, forKeyPath: Observer.bounds.keyPath, options: [.new], context: &Observer.bounds.context)
//        }
//    }
//    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        guard let context = context else {
//            return super.observeValue(forKeyPath: keyPath, of: object, change: change, context: nil)
//        }
//        
//        switch context {
//        case &Observer.frame.context, &Observer.bounds.context:
//            self.frame = self.superview!.bounds
//        default:
//            return super.observeValue(forKeyPath: keyPath, of: object, change: change, context: nil)
//        }
//    }
//}

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
extension UITableView: EmptyPlaceholderView {
    typealias HostView = UITableView
    
    @objc
    func swz_reloadData() {
        self.swz_reloadData()
        
        guard let configuration = self.configuration else {
            return
        }
        
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
    
    private static func didSwizzle() {
        func exchangeSelector(_ selector1: Selector, _ selector2: Selector) {
            let m1 = class_getInstanceMethod(UITableView.self, selector1)
            let m2 = class_getInstanceMethod(UITableView.self, selector2)
            method_exchangeImplementations(m1, m2)
        }
        exchangeSelector(#selector(reloadData), #selector(swz_reloadData))
    }
    
    fileprivate static let didSwizzleOnce = didSwizzle()
}

extension UICollectionView: EmptyPlaceholderView {
    typealias HostView = UICollectionView
    
    @objc
    func swz_reloadData() {
        self.swz_reloadData()
        
        guard let configuration = self.configuration else {
            return
        }
        
        configuration.hasViewsInView = collectionViewLayout.layoutAttributesForElements(in: frame)?.count ?? 0 > 0
        
        reloadPlaceholder(force: true)
    }
    
    private static func didSwizzle() {
        func exchangeSelector(_ selector1: Selector, _ selector2: Selector) {
            let m1 = class_getInstanceMethod(UICollectionView.self, selector1)
            let m2 = class_getInstanceMethod(UICollectionView.self, selector2)
            method_exchangeImplementations(m1, m2)
        }
        exchangeSelector(#selector(reloadData), #selector(swz_reloadData))
    }
    
    fileprivate static let didSwizzleOnce = didSwizzle()
    
}

// Extension UITableView and UICollection
extension InstanceExtension where Base: UITableView {
    public var placeholder: PlaceholderConfiguration<UITableView> {
        assertMainThread()
        _ = UITableView.didSwizzleOnce
        return (base as UITableView).configurationIfNeeded()
    }
}

extension InstanceExtension where Base: UICollectionView {
    public var placeholder: PlaceholderConfiguration<UICollectionView> {
        assertMainThread()
        _ = UICollectionView.didSwizzleOnce
        return (base as UICollectionView).configurationIfNeeded()
    }
}
