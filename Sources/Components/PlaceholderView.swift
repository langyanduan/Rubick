//
//  PlaceholderView.swift
//  Rubick
//
//  Created by WuFan on 2016/10/19.
//
//

import Foundation

//class PlaceholderObserverView: UIView {
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


class PlaceholderView: UIView {
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    let titleLabel = UILabel().then { label in
        label.textColor = UIColor(white: 0.6, alpha: 1)
    }
    let descriptionLabel: UILabel = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
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
