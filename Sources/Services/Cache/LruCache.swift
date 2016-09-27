//
//  LinkedHashMap.swift
//  Rubick
//
//  Created by WuFan on 2016/9/26.
//
//

import Foundation

class LruCacheNode<Key, Value> {
    var next: LruCacheNode<Key, Value>?
    var prev: LruCacheNode<Key, Value>?
    
    let key: Key
    var value: Value
    var cost: Int = 0
    var hitTime: TimeInterval = 0
    
    init(key: Key, value: Value) {
        self.key = key
        self.value = value
    }
}

class LruCache<Key: Hashable, Value> {
    private typealias Node = LruCacheNode<Key, Value>
    
    private var lock = pthread_mutex_t()
    private var storage = Dictionary<Key, Node>()
    private var head: Node?
    private var tail: Node?
    
    private let countLimit: Int
    private let costLimit: Int
    
    public var count: Int { return storage.count }
    public private(set) var costCount = 0
    
    public init(countLimit: Int = 0, costLimit: Int = 0) {
        self.countLimit = countLimit
        self.costLimit = costLimit
    }
    
    public func contains(_ key: Key) -> Bool {
        pthread_mutex_lock(&lock); defer { pthread_mutex_unlock(&lock) }
        return storage[key] != nil
    }
    
    public func value(forKey key: Key) -> Value? {
        pthread_mutex_lock(&lock); defer { pthread_mutex_unlock(&lock) }
        guard let node = storage[key] else {
            return nil
        }
        node.hitTime = CACurrentMediaTime()
        
        _bringNode(toHead: node)
        return node.value
    }
    
    public func set(value: Value, forKey key: Key, withCost cost: Int = 0) {
        pthread_mutex_lock(&lock); defer { pthread_mutex_unlock(&lock) }
        
        if let node = storage[key] {
            node.value = value
            node.hitTime = CACurrentMediaTime()
            
            costCount -= node.cost
            node.cost = cost
            costCount += cost
            
            _bringNode(toHead: node)
        } else {
            let node = Node(key: key, value: value)
            node.hitTime = CACurrentMediaTime()
            
            node.cost = cost
            costCount += cost
            
            storage[key] = node
            
            _insertNode(atHead: node)
        }
    }
    
    public func remove(forKey key: Key) {
        pthread_mutex_lock(&lock); defer { pthread_mutex_unlock(&lock) }
        
        guard let node = storage[key] else {
            return
        }
        
        storage[key] = nil
        costCount -= node.cost
        
        _removeNode(node)
    }
    
    public func removeAll() {
        pthread_mutex_lock(&lock); defer { pthread_mutex_unlock(&lock) }
        storage.removeAll()
        
        var nextNode: Node? = head
        repeat {
            guard let node = nextNode else {
                break
            }
            nextNode = node.next
            node.next = nil
        } while nextNode != nil
        head = nil
        tail = nil
        costCount = 0
    }
    
    public func trim() {
        pthread_mutex_lock(&lock); defer { pthread_mutex_unlock(&lock) }
        
        let costOverflow = costLimit > 0 && costCount > costLimit
        let countOverflow = countLimit > 0 && count > countLimit
        
        if !costOverflow && !countOverflow {
            return
        }
        
        let costNeedRemoved = costOverflow ? costCount - costLimit : 0
        let countNeedRemoved = countOverflow ? count - countLimit : 0
        
        _trim(costNeedRemoved: costNeedRemoved, countNeedRemoved: countNeedRemoved, hitTimeLimit: nil)
    }
    
    public func trim(toCount count: Int) {
        pthread_mutex_lock(&lock); defer { pthread_mutex_unlock(&lock) }
        
        if count >= self.count {
            return
        }
        
        let countNeedRemoved = self.count - count
        
        _trim(costNeedRemoved: 0, countNeedRemoved: countNeedRemoved, hitTimeLimit: nil)
    }
    
    public func trim(toCost cost: Int) {
        pthread_mutex_lock(&lock); defer { pthread_mutex_unlock(&lock) }
        
        if cost >= costCount {
            return
        }
        
        let costNeedRemoved = costCount - cost
        
        _trim(costNeedRemoved: costNeedRemoved, countNeedRemoved: 0, hitTimeLimit: nil)
    }
    
    public func trim(toAge age: TimeInterval) {
        pthread_mutex_lock(&lock); defer { pthread_mutex_unlock(&lock) }
        
        let hitTimeLimit = CACurrentMediaTime() - age
        if count == 0 {
            return
        }
        if let tail = self.tail, tail.hitTime >= hitTimeLimit {
            return
        }
        
        _trim(costNeedRemoved: 0, countNeedRemoved: 0, hitTimeLimit: hitTimeLimit)
    }
    
    // Private: node operate
    private func _bringNode(toHead node: Node) {
        switch (node.prev, node.next) {
        case (nil, _):
            return
        case let (prev?, next?):
            prev.next = next
            next.prev = prev
        case let (prev?, nil):
            prev.next = nil
            tail = prev
        }
        
        node.prev = nil
        node.next = head
        head?.prev = node
        head = node
    }
    
    private func _insertNode(atHead node: Node) {
        if let head = head {
            head.prev = node
            node.next = head
            self.head = node
        } else {
            head = node
            tail = node
        }
    }
    
    private func _removeNode(_ node: Node) {
        switch (node.prev, node.next) {
        case let (prev?, next?):
            prev.next = next
            next.prev = prev
        case let (prev?, nil):
            prev.next = nil
            tail = prev
        case let (nil, next?):
            next.prev = nil
            head = next
        case (nil, nil):
            head = nil
            tail = nil
        }
    }

    // Private: trim operate
    
    private func _trim(costNeedRemoved: Int, countNeedRemoved: Int, hitTimeLimit: TimeInterval?) {
        var costTailCount = 0
        var countTailCount = 0
        var lastNode: Node? = tail
        var timeoutHasAllRemoved = hitTimeLimit == nil

        repeat {
            guard let node = lastNode else {
                assertionFailure()
                return
            }
            lastNode = node.prev
            
            costTailCount += node.cost
            countTailCount += 1
            
            node.prev = nil
            storage[node.key] = nil
            
            if !timeoutHasAllRemoved {
                if let prev = lastNode {
                    timeoutHasAllRemoved = prev.hitTime >= hitTimeLimit!
                } else {
                    timeoutHasAllRemoved = true
                }
            }
            
            if !timeoutHasAllRemoved { continue }
            if costTailCount < costNeedRemoved { continue }
            if countTailCount < countNeedRemoved { continue }
            
            if let prev = lastNode {
                prev.next = nil
                tail = prev
            } else {
                head = nil
                tail = nil
            }
            costCount -= costTailCount
            
            return
            
        } while lastNode != nil
        
        assertionFailure()
    }

}
