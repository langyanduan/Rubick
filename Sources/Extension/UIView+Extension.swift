//
//  UIView+Extension.swift
//  Rubick
//
//  Created by wufan on 16/8/25.
//
//

import UIKit

extension InstanceExtension where Base: UIView {
    public var viewController: UIViewController? {
        var nextResponse: UIResponder? = base
        
        while let nextResponse = nextResponse?.next {
            if let viewController = nextResponse as? UIViewController {
                return viewController
            }
        }
        
        return nil
    }
}
