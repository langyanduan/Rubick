//
//  Cache.swift
//  Rubick
//
//  Created by WuFan on 16/9/19.
//
//

import Foundation

public protocol Cache {
    associatedtype Element
    
    func containsObject(forKey key: String) -> Bool
    func object(forKey key: String) -> Element?
    func setObject(_ object: Element, forKey key: String)
    
    func containsObject(forKey key: String, _ closure: @escaping (Self, String, Bool) -> Void)
    func object(forKey key: String, _ closure: @escaping (Self, String, Element?) -> Void)
    func setObject(_ object: Element, forKey key: String, _ closure: @escaping (Self, String, Element?) -> Void)
    
    func removeObject(forKey key: String)
    func removeAllObjects()
}
