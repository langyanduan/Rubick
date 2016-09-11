//
//  ImageLabel.swift
//  Rubick
//
//  Created by wufan on 16/8/19.
//
//

import UIKit

open class ImageLabel: UIView {
    public enum ImagePosition {
        case top
        case left
        case bottom
        case right
        case background
    }
    
    open var font: UIFont? {
        get {
            return textLabel.font
        }
        set {
            textLabel.font = newValue
            reloadLayout()
        }
    }
    open var text: String? {
        get {
            return textLabel.text
        }
        set {
            textLabel.text = newValue
            reloadLayout()
        }
    }
    
    open var textColor: UIColor! {
        get {
            return textLabel.textColor
        }
        set {
            textLabel.textColor = newValue
        }
    }
    open var highlightedTextColor: UIColor? {
        get {
            return textLabel.highlightedTextColor
        }
        set {
            textLabel.highlightedTextColor = newValue
        }
    }
    open var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.setNeedsDisplay()
            reloadLayout()
        }
    }
    open var highlightedImage: UIImage? {
        get {
            return imageView.highlightedImage
        }
        set {
            imageView.highlightedImage = newValue
            imageView.setNeedsDisplay()
            reloadLayout()
        }
    }
    
    open var attributedText: NSAttributedString? {
        get {
            return textLabel.attributedText
        }
        set {
            textLabel.attributedText = newValue
            reloadLayout()
        }
    }
    
    open var highlighted: Bool = false {
        didSet {
            textLabel.isHighlighted = highlighted
            imageView.isHighlighted = highlighted
            reloadLayout()
        }
    }
    open var imagePosition: ImagePosition = .top
    open var spaceing: CGFloat = 0
    open var offset: CGFloat = 0
    
    
    private lazy var textLabel: UILabel = UILabel()
    private lazy var imageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.addSubview(imageView)
        self.addSubview(textLabel)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = imageView.intrinsicContentSize
        let labelSize = textLabel.intrinsicContentSize
        let size = bounds.size
        
        switch imagePosition {
        case .top:
            imageView.frame = CGRect(x: (size.width - imageSize.width) / 2,
                                     y: (size.height - labelSize.height - imageSize.height - spaceing) / 2 + offset,
                                     width: imageSize.width,
                                     height: imageSize.height)
            textLabel.frame = CGRect(x: (size.width - labelSize.width) / 2,
                                     y: imageView.frame.maxY + spaceing + offset,
                                     width: labelSize.width,
                                     height: labelSize.height)
        case .bottom:
            textLabel.frame = CGRect(x: (size.width - labelSize.width) / 2,
                                     y: (size.height - labelSize.height - imageSize.height - spaceing) / 2 + offset,
                                     width: labelSize.width,
                                     height: labelSize.height)
            imageView.frame = CGRect(x: (size.width - imageSize.width) / 2,
                                     y: textLabel.frame.maxY + spaceing + offset,
                                     width: imageSize.width,
                                     height: imageSize.height)
        case .left:
            imageView.frame = CGRect(x: (size.width - labelSize.width - imageSize.width - spaceing) / 2 + offset,
                                     y: (size.height - imageSize.height) / 2,
                                     width: imageSize.width,
                                     height: imageSize.height)
            textLabel.frame = CGRect(x: imageView.frame.maxX + spaceing + offset,
                                     y: (size.height - labelSize.height) / 2,
                                     width: labelSize.width,
                                     height: labelSize.height)
        case .right:
            textLabel.frame = CGRect(x: (size.width - labelSize.width - imageSize.width - spaceing) / 2 + offset,
                                     y: (size.height - labelSize.height) / 2,
                                     width: labelSize.width,
                                     height: labelSize.height)
            imageView.frame = CGRect(x: textLabel.frame.maxX + spaceing + offset,
                                     y: (size.height - imageSize.height) / 2,
                                     width: imageSize.width,
                                     height: imageSize.height)
        case .background:
            textLabel.frame = CGRect(x: (size.width - labelSize.width) / 2,
                                     y: (size.height - labelSize.height) / 2,
                                     width: labelSize.width,
                                     height: labelSize.height)
            imageView.frame = CGRect(x: (size.width - imageSize.width) / 2,
                                     y: (size.height - imageSize.height) / 2,
                                     width: imageSize.width,
                                     height: imageSize.height)
        }
    }
    
    override open var intrinsicContentSize : CGSize {
        let imageSize = imageView.intrinsicContentSize
        let labelSize = textLabel.intrinsicContentSize
        switch imagePosition {
        case .top, .bottom:
            return CGSize(width: max(imageSize.width, labelSize.width),
                          height: imageSize.height + labelSize.height + spaceing)
        case .left, .right:
            return CGSize(width: imageSize.width + labelSize.width + spaceing,
                          height: max(imageSize.height, labelSize.height))
        case .background:
            return CGSize(width: max(imageSize.width, labelSize.width),
                          height: max(imageSize.height, labelSize.height))
        }
    }
    
    override open func sizeToFit() {
        bounds = CGRect(origin: CGPoint.zero, size: intrinsicContentSize)
    }
    
    private func reloadLayout() {
        imageView.setNeedsDisplay()
        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }
}
