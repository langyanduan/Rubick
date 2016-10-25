//
//  LayoutItem.swift
//  Rubick
//
//  Created by WuFan on 2016/10/25.
//
//

import Foundation
import UIKit

public struct LayoutItem {
    let view: UIView
    let attribute: NSLayoutAttribute
}

public struct LayoutCenterItem {
    let view: UIView
}

public struct LayoutSizeItem {
    let view: UIView
}

public struct LayoutEdgesItem {
    let view: UIView
    let insets: UIEdgeInsets
    
    init(view: UIView, insets: UIEdgeInsets = .zero) {
        self.view = view
        self.insets = insets
    }
}
