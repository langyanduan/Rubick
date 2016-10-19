//
//  UIScrollVIew+InfiniteScrolling.swift
//  Rubick
//
//  Created by WuFan on 2016/10/13.
//
//

import Foundation

private let FooterHeight: CGFloat = 40

private struct Observer {
    struct contentOffset {
        static let keyPath = "contentOffset"
        static var context = 0
    }
    struct contentSize {
        static let keyPath = "contentSize"
        static var context = 0
    }
}

private enum RefreshState {
    case normal
    case loading
    case finish
}

private class FooterView: UIView, NextLoadable {
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // Loadable
    func stopAnimating() {
        state = .normal
    }

    func startAnimating() {
        state = .loading
    }
    
    func finish() {
        state = .finish
    }
    
    var handler: (() -> Void)?
    var isEnable: Bool = true
    
    var originInsets: UIEdgeInsets = .zero
    var isAnimating: Bool { return state == .loading }
    var state: RefreshState = .normal {
        didSet {
            guard oldValue != state else { return }
            
            switch state {
            case .normal:
                indicatorView.stopAnimating()
            case .loading:
                indicatorView.startAnimating()
            case .finish:
                indicatorView.stopAnimating()
            }
            
            textLabel.isHidden = oldValue == .finish || state != .finish
        }
    }
    
    //
    
    var finishText: String = "" {
        didSet {
            textLabel.text = finishText
        }
    }
    weak var scrollView: UIScrollView!
    
    override init(frame: CGRect) {
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
            
            originInsets = scrollView.contentInset
            self.scrollView = scrollView
        }
    }
    
    override func didMoveToSuperview() {
        if let scrollView = superview as? UIScrollView {
            frame = CGRect(x: 0, y: scrollView.contentSize.height, width: scrollView.frame.width, height: FooterHeight)
        }
    }
    
    var textLabel: UILabel!
    var indicatorView: IndicatorView!
    
    func setup() {
        autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        
        indicatorView = IndicatorView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicatorView)
        
        textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.text = "加载完成..."
        textLabel.textColor = UIColor(white: 0.6, alpha: 1)
        textLabel.font = UIFont.systemFont(ofSize: 14)
        textLabel.isHidden = true
        addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            indicatorView.centerX == self.centerX,
            indicatorView.centerY == self.centerY,
            textLabel.centerX == self.centerX,
            textLabel.centerY == self.centerY
        ])
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
        guard isEnable else { return }
        if state == .finish { return }
        if scrollView.ext.isPullRefreshAnimating { return }
        guard !scrollView.frame.isEmpty, scrollView.contentSize.height > scrollView.bounds.height else { return }
        
        if scrollView.contentOffset.y + scrollView.frame.height >= scrollView.contentSize.height && state != .loading {
            state = .loading
            handler?()
        }
    }
    
    func sizeChanged() {
        frame = CGRect(x: 0, y: scrollView.contentSize.height + originInsets.bottom, width: scrollView.frame.width, height: FooterHeight)
        
        var insets = scrollView.contentInset
        insets.bottom = originInsets.bottom + FooterHeight
        scrollView.contentInset = insets
    }
}

private var associatedFooterKey = 0

extension InstanceExtension where Base: UIScrollView {
    private var footerView: FooterView? {
        return objc_getAssociatedObject(base, &associatedFooterKey) as? FooterView
    }
    
    public var infiniteScrollingView: NextLoadable? { return footerView }
    public var isInfiniteScrollingAnimating: Bool { return footerView?.isAnimating ?? false }
    
    public func addInfiniteScrolling(with handler: @escaping () -> Void) {
        if let view = footerView {
            view.handler = handler
        } else {
            let view = FooterView()
            view.finishText = "没有更多数据了..."
            view.handler = handler
            base.addSubview(view)
            objc_setAssociatedObject(base, &associatedFooterKey, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func startInfiniteScrollingHandler() {
        footerView?.startAnimating()
        footerView?.handler?()
    }
    public func startInfiniteScrolling() {
        footerView?.startAnimating()
    }
    public func stopInfiniteScrolling(with hasNext: Bool = true) {
        if hasNext {
            footerView?.stopAnimating()
        } else {
            footerView?.finish()
        }
    }
}
