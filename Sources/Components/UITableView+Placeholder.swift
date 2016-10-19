//
//  UITableView+Placeholder.swift
//  Rubick
//
//  Created by WuFan on 2016/10/19.
//
//

import Foundation
import UIKit

extension UITableView: PlaceholderProtocol {
    @objc
    private func swz_reloadData() {
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
        let m1 = class_getInstanceMethod(UICollectionView.self, #selector(reloadData))
        let m2 = class_getInstanceMethod(UICollectionView.self, #selector(swz_reloadData))
        method_exchangeImplementations(m1, m2)
    }
    
    fileprivate static let didSwizzleOnce = didSwizzle()
}

extension InstanceExtension where Base: UITableView {
    public var placeholder: PlaceholderConfiguration<UITableView> {
        _ = UITableView.didSwizzleOnce
        return (base as UITableView).configurationIfNeeded()
    }
}
