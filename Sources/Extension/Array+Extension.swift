//
//  Array+Extension.swift
//  Rubick
//
//  Created by wufan on 16/8/19.
//
//

import Foundation

extension Array {
    public func rbk_forEachPair(@noescape clousre: (Element, Element) -> Void) {
        guard count > 1 else {
            return
        }
        for index in 0 ..< count - 1 {
            let item1 = self[index]
            let item2 = self[index + 1]
            clousre(item1, item2)
        }
    }
}