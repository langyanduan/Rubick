//
//  RefreshView.swift
//  Rubick
//
//  Created by WuFan on 16/9/13.
//
//

import UIKit

public protocol Loadable {
    var isAnimating: Bool { get }
    var isEnable: Bool { set get }
    var handler: (() -> Void)? { set get }
    var originInsets: UIEdgeInsets { set get }
    
    func startAnimating()
    func stopAnimating()
}

enum RefreshState {
    case normal
    case triggering
    case loading
}
