//
//  UIScrollView+Placeholder.swift
//  Rubick
//
//  Created by WuFan on 2016/10/19.
//
//

import Foundation
import UIKit

extension UICollectionView: PlaceholderProtocol {
    @objc
    private func swz_reloadData() {
        self.swz_reloadData()
        
        guard let configuration = self.configuration else {
            return
        }
        
        configuration.hasViewsInView = collectionViewLayout.layoutAttributesForElements(in: frame)?.count ?? 0 > 0
        
        reloadPlaceholder(force: true)
    }
    
    private static func didSwizzle() {
        let m1 = class_getInstanceMethod(UICollectionView.self, #selector(reloadData))
        let m2 = class_getInstanceMethod(UICollectionView.self, #selector(swz_reloadData))
        method_exchangeImplementations(m1, m2)
    }
    
    fileprivate static let didSwizzleOnce = didSwizzle()
}

extension InstanceExtension where Base: UICollectionView {
    public var placeholder: PlaceholderConfiguration<UICollectionView> {
        _ = UICollectionView.didSwizzleOnce
        return (base as UICollectionView).configurationIfNeeded()
    }
}
