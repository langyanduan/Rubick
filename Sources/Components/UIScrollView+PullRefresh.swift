//
//  UIScrollView+PullRefresh.swift
//  Rubick
//
//  Created by WuFan on 2016/10/13.
//
//

import Foundation
import UIKit

private let HeaderHeight: CGFloat = 60

private enum RefreshState {
    case normal
    case triggering
    case loading
}

private class HeaderView: UIView, Loadable {
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private struct Observer {
        struct contentOffset {
            static let keyPath = "contentOffset"
            static var context = 0
        }
    }
    
    weak var scrollView: UIScrollView!
    var originInsets: UIEdgeInsets = .zero
    var state: RefreshState = .normal {
        didSet {
            guard oldValue != state else {
                return
            }
            switch state {
            case .normal where oldValue == .loading:
                progressView.stopAnimation()
                
                UIView.animate(withDuration: 0.25, animations: { 
                    self.scrollView.contentInset = self.originInsets
                })
                
//                let offset = scrollView.contentOffset
//                scrollView.contentInset = originInsets
//                scrollView.contentOffset = offset
//                scrollView.setContentOffset(CGPoint(x: -originInsets.left, y: -originInsets.top), animated: true)
                
            case .loading:
                progressView.startAnimating()
                
                let offset = scrollView.contentOffset
                scrollView.contentInset = UIEdgeInsets(top: HeaderHeight, left: originInsets.left, bottom: originInsets.bottom, right: originInsets.right)
                scrollView.contentOffset = offset
                scrollView.setContentOffset(CGPoint(x: -originInsets.left, y: -HeaderHeight), animated: true)
            default:
                progressView.stopAnimation()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if let scrollView = superview as? UIScrollView {
            scrollView.removeObserver(self, forKeyPath: Observer.contentOffset.keyPath)
            scrollView.panGestureRecognizer.removeTarget(self, action: #selector(onPanGesture))
        }
        
        if let scrollView = newSuperview as? UIScrollView {
            originInsets = scrollView.contentInset
            scrollView.panGestureRecognizer.addTarget(self, action: #selector(onPanGesture))
            scrollView.addObserver(self, forKeyPath: Observer.contentOffset.keyPath, options: [.new], context: &Observer.contentOffset.context)
            self.scrollView = scrollView
        }
    }
    
    override func didMoveToSuperview() {
        if let scrollView = superview {
            frame = CGRect(x: 0, y: -HeaderHeight, width: scrollView.frame.width, height: HeaderHeight)
        }
    }
    
    var progressView: ProgressIndicatorView!
    
    func setup() {
        autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        
        progressView = ProgressIndicatorView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressView)
        NSLayoutConstraint(item: progressView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: progressView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
    
    @objc
    func onPanGesture(_ gesture: UIPanGestureRecognizer) {
        switch (gesture.state, state) {
        case (.ended, .triggering):
            state = .loading
            handler?()
        default:
            break
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
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
        guard isEnable else { return }
        
        let offset = scrollView.contentOffset.y
        let trigger = offset <= -HeaderHeight
        
        // iOS 10 上 UIScrollView 状态存在延迟, 通过监听手势解决. see onGesturePan
        switch state {
        case .normal where trigger:
            state = .triggering
        case .triggering where !trigger:
            state = .normal
        default:
            break
        }
        
        if state != .loading {
            progressView.progress = (-offset - HeaderHeight / 2) / HeaderHeight * 2
        }
    }
    
    var handler: (() -> Void)?
    var isEnable: Bool = true
    
    var isAnimating: Bool {
        return state == .loading
    }
    
    func startAnimating() {
        state = .loading
    }
    func stopAnimating() {
        state = .normal
    }
}

private var associatedHeaderKey = 0

extension InstanceExtension where Base: UIScrollView {
    private var headerView: HeaderView? {
        return objc_getAssociatedObject(base, &associatedHeaderKey) as? HeaderView
    }
    
    public var pullRefreshView: Loadable? { return headerView }
    
    public func addPullToRefresh(with handler: @escaping () -> Void) {
        if let view = headerView {
            view.handler = handler
        } else {
            let view = HeaderView()
            view.handler = handler
            base.addSubview(view)
            objc_setAssociatedObject(base, &associatedHeaderKey, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func startPullRefresh() {
        headerView?.startAnimating()
    }
    public func startPullRefreshHandler() {
        headerView?.startAnimating()
        headerView?.handler?()
    }
    public func stopPullRefresh() {
        headerView?.stopAnimating()
    }
}
