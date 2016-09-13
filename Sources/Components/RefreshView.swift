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
    
    unowned var scrollView: UIScrollView
    var originInsets: UIEdgeInsets = .zero
    var state: RefreshState = .normal
    var handler: (() -> Void)?
    
    
    var textLabel: UILabel!
    var lastWidth: CGFloat = 0
    
    init(_ scrollView: UIScrollView) {
        self.scrollView = scrollView
        super.init(frame: CGRect.zero)
        
        setup()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        superview?.removeObserver(self, forKeyPath: Observer.contentOffset.keyPath)
        
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
//        case &Observer.frame.context:
//            frameChanged()
        case &Observer.contentOffset.context:
            offsetChanged()
        default:
            return super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func frameChanged() {
        if scrollView.frame.width == lastWidth {
            return
        }
        
        lastWidth = scrollView.frame.width
        
        frame = CGRect(x: 0, y: 0, width: lastWidth, height: LoadingHeight)
        setNeedsLayout()
    }
    
    func offsetChanged() {
    }
    
    
    var animated: Bool {
        return state == .loading
    }
    func trigger() { }
    func stop() { }
}

extension InstanceExtension where Base: UIScrollView {
    private var loadingView: LoadingView? {
        return objc_getAssociatedObject(self, &AssociatedKey.LoadingView) as? LoadingView 
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
            objc_setAssociatedObject(self, &AssociatedKey.LoadingView, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension InstanceExtension where Base: UIScrollView {
    public func addInfiniteRefresh(_ closure: () -> Void) {
        
    }
}

