//
//  ImageLabel.swift
//  Rubick
//
//  Created by wufan on 16/8/19.
//
//

import UIKit

public class ImageLabel: UIView {
    public enum ImagePosition {
        case Top
        case Left
        case Bottom
        case Right
        case Background
    }
    
    public var font: UIFont? {
        get {
            return textLabel.font
        }
        set {
            textLabel.font = newValue
            reloadLayout()
        }
    }
    public var text: String? {
        get {
            return textLabel.text
        }
        set {
            textLabel.text = newValue
            reloadLayout()
        }
    }
    
    public var textColor: UIColor! {
        get {
            return textLabel.textColor
        }
        set {
            textLabel.textColor = newValue
        }
    }
    public var highlightedTextColor: UIColor? {
        get {
            return textLabel.highlightedTextColor
        }
        set {
            textLabel.highlightedTextColor = newValue
        }
    }
    public var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.setNeedsDisplay()
            reloadLayout()
        }
    }
    public var highlightedImage: UIImage? {
        get {
            return imageView.highlightedImage
        }
        set {
            imageView.highlightedImage = newValue
            imageView.setNeedsDisplay()
            reloadLayout()
        }
    }
    
    public var attributedText: NSAttributedString? {
        get {
            return textLabel.attributedText
        }
        set {
            textLabel.attributedText = newValue
            reloadLayout()
        }
    }
    
    public var highlighted: Bool = false {
        didSet {
            textLabel.highlighted = highlighted
            imageView.highlighted = highlighted
            reloadLayout()
        }
    }
    public var imagePosition: ImagePosition = .Top
    public var spaceing: CGFloat = 0
    public var offset: CGFloat = 0
    
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
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
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = imageView.intrinsicContentSize()
        let labelSize = textLabel.intrinsicContentSize()
        let size = bounds.size
        
        switch imagePosition {
        case .Top:
            imageView.frame = CGRect(x: (size.width - imageSize.width) / 2,
                                     y: (size.height - labelSize.height - imageSize.height - spaceing) / 2 + offset,
                                     width: imageSize.width,
                                     height: imageSize.height)
            textLabel.frame = CGRect(x: (size.width - labelSize.width) / 2,
                                     y: imageView.frame.maxY + spaceing + offset,
                                     width: labelSize.width,
                                     height: labelSize.height)
        case .Bottom:
            textLabel.frame = CGRect(x: (size.width - labelSize.width) / 2,
                                     y: (size.height - labelSize.height - imageSize.height - spaceing) / 2 + offset,
                                     width: labelSize.width,
                                     height: labelSize.height)
            imageView.frame = CGRect(x: (size.width - imageSize.width) / 2,
                                     y: textLabel.frame.maxY + spaceing + offset,
                                     width: imageSize.width,
                                     height: imageSize.height)
        case .Left:
            imageView.frame = CGRect(x: (size.width - labelSize.width - imageSize.width - spaceing) / 2 + offset,
                                     y: (size.height - imageSize.height) / 2,
                                     width: imageSize.width,
                                     height: imageSize.height)
            textLabel.frame = CGRect(x: imageView.frame.maxX + spaceing + offset,
                                     y: (size.height - labelSize.height) / 2,
                                     width: labelSize.width,
                                     height: labelSize.height)
        case .Right:
            textLabel.frame = CGRect(x: (size.width - labelSize.width - imageSize.width - spaceing) / 2 + offset,
                                     y: (size.height - labelSize.height) / 2,
                                     width: labelSize.width,
                                     height: labelSize.height)
            imageView.frame = CGRect(x: textLabel.frame.maxX + spaceing + offset,
                                     y: (size.height - imageSize.height) / 2,
                                     width: imageSize.width,
                                     height: imageSize.height)
        case .Background:
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
    
    override public func intrinsicContentSize() -> CGSize {
        let imageSize = imageView.intrinsicContentSize()
        let labelSize = textLabel.intrinsicContentSize()
        switch imagePosition {
        case .Top, .Bottom:
            return CGSize(width: max(imageSize.width, labelSize.width),
                          height: imageSize.height + labelSize.height + spaceing)
        case .Left, .Right:
            return CGSize(width: imageSize.width + labelSize.width + spaceing,
                          height: max(imageSize.height, labelSize.height))
        case .Background:
            return CGSize(width: max(imageSize.width, labelSize.width),
                          height: max(imageSize.height, labelSize.height))
        }
    }
    
    override public func sizeToFit() {
        bounds = CGRect(origin: CGPointZero, size: intrinsicContentSize())
    }
    
    private func reloadLayout() {
        imageView.setNeedsDisplay()
        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }
}
