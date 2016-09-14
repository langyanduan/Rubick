//
//  RefreshView.swift
//  Rubick
//
//  Created by WuFan on 16/9/13.
//
//

import UIKit

private struct AssociatedKey {
    static var HeaderView = 0
    static var FooterView = 0
}


protocol Loadable {
    var animating: Bool { get }
    var enable: Bool { set get }
    var handler: (() -> Void)? { set get }
    var originInsets: UIEdgeInsets { set get }
    
    func trigger()
    func stop()
}

enum RefreshState {
    case normal
    case triggering
    case loading
    case finished
}

private let HeaderHeight: CGFloat = 60
private let FooterHeight: CGFloat = 40

private class HeaderView: UIView, Loadable {
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private struct Observer {
        struct contentOffset {
            static let keyPath = "contentOffset"
            static var context = 0
        }
    }
    
    private struct Text {
        static let loading = "正在刷新"
        static let normal = "下拉刷新"
        static let triggering = "释放刷新"
        static let finished = "完成刷新"
    }
    
    unowned var scrollView: UIScrollView
    var originInsets: UIEdgeInsets = .zero
    var state: RefreshState = .normal
    var handler: (() -> Void)?
    var enable: Bool = true
    
    var textLabel: UILabel!
    
    init(_ scrollView: UIScrollView) {
        self.scrollView = scrollView
        super.init(frame: CGRect.zero)
        
        setup()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if let scrollView = superview as? UIScrollView {
            scrollView.removeObserver(self, forKeyPath: Observer.contentOffset.keyPath)
        }
        
        if let scrollView = newSuperview as? UIScrollView {
            scrollView.addObserver(self, forKeyPath: Observer.contentOffset.keyPath, options: [.new], context: &Observer.contentOffset.context)
        }
    }
    
    override func didMoveToSuperview() {
        if let scrollView = superview {
            frame = CGRect(x: 0, y: -HeaderHeight, width: scrollView.frame.width, height: HeaderHeight)
        }
    }
    
    func setup() {
        autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        originInsets = scrollView.contentInset
        
        textLabel = UILabel()
        textLabel.textColor = UIColor.red
        textLabel.text = "正在加载"
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(textLabel)
        
        NSLayoutConstraint(item: textLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: textLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        scrollView.addSubview(self)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        LogD(keyPath)
        guard let context = context else {
            return super.observeValue(forKeyPath: keyPath, of: object, change: change, context: nil)
        }
        
        switch context {
        case &Observer.contentOffset.context:
            offsetChanged()
        default:
            return super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func offsetChanged() {
        let offset = scrollView.contentOffset.y
        
        if offset <= -HeaderHeight {
            switch state {
            case .normal:
                setState(.triggering, animated: true)
            case .triggering:
                if !scrollView.isTracking && !scrollView.isDragging {
                    setState(.loading, animated: true)
                    handler?()
                    UIView.animate(withDuration: 0.25) {
                        self.scrollView.contentInset = UIEdgeInsets(top: HeaderHeight, left: 0, bottom: 0, right: 0)
                    }
                }
            case .finished:
                break
            case .loading:
                break
            }
        } else {
            switch state {
            case .triggering:
                setState(.normal, animated: true)
            case .loading:
                break
            case .finished:
                break
            case .normal:
                break
            }
        }
    }
    
    func setState(_ state: RefreshState, animated: Bool = false) {
        switch state {
        case .normal:
            textLabel.text = Text.normal
        case .loading:
            textLabel.text = Text.loading
        case .finished:
            textLabel.text = Text.finished
        case .triggering:
            textLabel.text = Text.triggering
        }
        self.state = state
    }
    
    var animating: Bool {
        return state == .loading
    }
    func trigger() {
        setState(.loading)
        UIView.animate(withDuration: 0.25) {
            self.scrollView.contentInset = UIEdgeInsets(top: HeaderHeight, left: 0, bottom: 0, right: 0)
            self.scrollView.contentOffset = CGPoint(x: 0, y: -HeaderHeight)
        }
    }
    func stop() {
        setState(.normal)
        UIView.animate(withDuration: 0.25) {
            self.scrollView.contentInset = self.originInsets
        }
    }
}

extension InstanceExtension where Base: UIScrollView {
    private var headerView: HeaderView? {
        return objc_getAssociatedObject(base, &AssociatedKey.HeaderView) as? HeaderView
    }
    
    public var originInsets: UIEdgeInsets {
        get {
            return headerView?.originInsets ?? .zero
        }
        set {
            headerView?.originInsets = newValue
        }
    }
    
    public func addPullToRefresh(with handler: @escaping () -> Void) {
        if let view = headerView {
            view.handler = handler
        } else {
            let view = HeaderView(base)
            view.handler = handler
            objc_setAssociatedObject(base, &AssociatedKey.HeaderView, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func triggerHeaderLoading() {
        headerView?.trigger()
    }
    public func triggerHeaderLoadingAndHandler() { }
    public func stopHeaderAnimating() {
        headerView?.stop()
    }
}

private class FooterView: UIView, Loadable {
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    struct Observer {
        struct contentOffset {
            static let keyPath = "contentOffset"
            static var context = 0
        }
        struct contentSize {
            static let keyPath = "contentSize"
            static var context = 0
        }
    }
    
    // Loadable
    func stop() {
        
    }

    func trigger() {
        
    }

    var handler: (() -> Void)?
    var enable: Bool = true {
        didSet {
            
        }
    }
    
    var originInsets: UIEdgeInsets = .zero
    var animating: Bool {
        return false
    }
    
    weak var scrollView: UIScrollView!
    var state: RefreshState = .normal
    
    init(_ scrollView: UIScrollView) {
        self.scrollView = scrollView
        super.init(frame: CGRect.zero)
        
        setup()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if let scrollView = superview as? UIScrollView {
            scrollView.removeObserver(self, forKeyPath: Observer.contentOffset.keyPath)
            scrollView.removeObserver(self, forKeyPath: Observer.contentSize.keyPath)
        }
        
        if let scrollView = newSuperview as? UIScrollView {
            scrollView.addObserver(self, forKeyPath: Observer.contentOffset.keyPath, options: [.new], context: &Observer.contentOffset.context)
            scrollView.addObserver(self, forKeyPath: Observer.contentSize.keyPath, options: [.new], context: &Observer.contentSize.context)
        }
    }
    
    override func didMoveToSuperview() {
        if let scrollView = superview as? UIScrollView {
            frame = CGRect(x: 0, y: scrollView.contentSize.height, width: scrollView.frame.width, height: FooterHeight)
        }
    }
    
    var textLabel: UILabel!
    
    func setup() {
        autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        
        textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.text = "iazai...."
        textLabel.textColor = UIColor.green
        addSubview(textLabel)
        
        NSLayoutConstraint(item: textLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: textLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        scrollView.addSubview(self)
    }
    
    private override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let context = context else {
            return
        }
        
        switch context {
        case &Observer.contentOffset.context:
            offsetChanged()
        case &Observer.contentSize.context:
            sizeChanged()
        default:
            break
        }
    }
    
    func offsetChanged() {
        guard enable else {
            return
        }
        guard scrollView.frame.width > 0, scrollView.frame.height > 0, scrollView.contentSize.height > 0 else {
            return
        }
        
        if scrollView.contentOffset.y >= self.frame.maxY - scrollView.frame.height {
            if state == .loading {
                return
            }
            setState(.loading)
            handler?()
        } else {
            if state == .loading {
                setState(.normal)
            }
        }
    }
    
    func setState(_ state: RefreshState, animate: Bool = false) {
        switch state {
        case .loading:
            textLabel.text = "正在加载"
        case .normal:
            textLabel.text = "加载完成"
        default:
            break
        }
        
        self.state = state
    }
    
    func sizeChanged() {
        frame = CGRect(x: 0, y: scrollView.contentSize.height + originInsets.bottom, width: scrollView.frame.width, height: FooterHeight)
        
        var insets = scrollView.contentInset
        insets.bottom = originInsets.bottom + FooterHeight
        scrollView.contentInset = insets
    }
}

extension InstanceExtension where Base: UIScrollView {
    private var footerView: FooterView? {
        return objc_getAssociatedObject(self, &AssociatedKey.FooterView) as? FooterView
    }
    
    public func addInfiniteScrolling(with handler: @escaping () -> Void) {
        if let view = footerView {
            view.handler = handler
        } else {
            let view = FooterView(base)
            view.handler = handler
            objc_setAssociatedObject(self, &AssociatedKey.FooterView, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func triggerFooterLoadingAndHandler() { }
    public func triggerFooterLoading() {
    }
    
    public func stopFooterAnimating(infinite: Bool = true) {
    }
}
