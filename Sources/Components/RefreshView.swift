//
//  RefreshView.swift
//  Rubick
//
//  Created by WuFan on 16/9/13.
//
//

import UIKit

private struct AssociatedKey {
    static var LoadingView = 0
}

private let LoadingHeight: CGFloat = 60

protocol RefreshView {
    var animated: Bool { get }
    
    func trigger()
    func stop()
}

enum RefreshState {
    case normal
    case triggering
    case loading
    case finished
}

class LoadingView: UIView, RefreshView {
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private struct Observer {
        struct contentOffset {
            static let keyPath = "contentOffset"
            static var context = 0
        }
//        struct frame {
//            static let keyPath = "frame"
//            static var context = 0
//        }
    }
    
    private struct StateText {
        static let loading = "正在刷新"
        static let normal = "下拉刷新"
        static let triggering = "释放刷新"
        static let finished = "完成刷新"
    }
    
    unowned var scrollView: UIScrollView
    var originInsets: UIEdgeInsets = .zero
    var state: RefreshState = .normal
    var handler: (() -> Void)?
    
    
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
            frame = CGRect(x: 0, y: -LoadingHeight, width: scrollView.frame.width, height: LoadingHeight)
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
        
        if offset <= -LoadingHeight {
            switch state {
            case .normal:
                setState(.triggering, animated: true)
            case .triggering:
                if !scrollView.isTracking && !scrollView.isDragging {
                    setState(.loading, animated: true)
                    
                    UIView.animate(withDuration: 0.25) {
                        self.scrollView.contentInset = UIEdgeInsets(top: LoadingHeight, left: 0, bottom: 0, right: 0)
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
            textLabel.text = StateText.normal
        case .loading:
            textLabel.text = StateText.loading
        case .finished:
            textLabel.text = StateText.finished
        case .triggering:
            textLabel.text = StateText.triggering
        }
        self.state = state
    }
    
    var animated: Bool {
        return state == .loading
    }
    func trigger() {
        setState(.loading)
        UIView.animate(withDuration: 0.25) {
            self.scrollView.contentInset = UIEdgeInsets(top: LoadingHeight, left: 0, bottom: 0, right: 0)
            self.scrollView.contentOffset = CGPoint(x: 0, y: -LoadingHeight)
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
    private var loadingView: LoadingView? {
        return objc_getAssociatedObject(base, &AssociatedKey.LoadingView) as? LoadingView
    }
    
    public var originInsets: UIEdgeInsets {
        get {
            return loadingView?.originInsets ?? .zero
        }
        set {
            loadingView?.originInsets = newValue
        }
    }
    
    public func addPullToRefresh(_ closure: @escaping () -> Void) {
        if let view = loadingView {
            view.handler = closure
        } else {
            let view = LoadingView(base)
            view.handler = closure
            objc_setAssociatedObject(base, &AssociatedKey.LoadingView, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func triggerLoading() {
        loadingView?.trigger()
    }
    public func stopLoading() {
        loadingView?.stop()
    }
}

extension InstanceExtension where Base: UIScrollView {
    public func addInfiniteRefresh(_ closure: () -> Void) {
        
    }
}

