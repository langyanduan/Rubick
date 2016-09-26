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
    typealias Node = LruCacheNode<Key, Value>
    
    private var lock = pthread_mutex_t()
    private var storage = Dictionary<Key, Node>()
    private var head: Node?
    private var tail: Node?
    
    private let countLimit: Int
    private let costLimit: Int
    
    public var count: Int { return storage.count }
    public private(set) var costCount = 0
    
    init(countLimit: Int = 0, costLimit: Int = 0) {
        self.countLimit = countLimit
        self.costLimit = costLimit
    }
    
    func contains(_ key: Key) -> Bool {
        pthread_mutex_lock(&lock); defer { pthread_mutex_unlock(&lock) }
        return storage[key] != nil
    }
    
    func value(forKey key: Key) -> Value? {
        pthread_mutex_lock(&lock); defer { pthread_mutex_unlock(&lock) }
        guard let node = storage[key] else {
            return nil
        }
        node.hitTime = CACurrentMediaTime()
        
        _bringNode(toHead: node)
        return node.value
    }
    
    func set(value: Value, forKey key: Key, withCost cost: Int = 0) {
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
    
    func remove(forKey key: Key) {
        pthread_mutex_lock(&lock); defer { pthread_mutex_unlock(&lock) }
        
        guard let node = storage[key] else {
            return
        }
        
        storage[key] = nil
        
        _removeNode(node)
    }
    
    func removeAll() {
        pthread_mutex_lock(&lock); defer { pthread_mutex_unlock(&lock) }
        storage.removeAll()
        head = nil
        tail = nil
    }
    
    func trim() {
        pthread_mutex_lock(&lock); defer { pthread_mutex_unlock(&lock) }
        _trim()
    }
    
    func trim(toCount count: Int) {
        pthread_mutex_lock(&lock); defer { pthread_mutex_unlock(&lock) }
        _trim(toCount: count)
    }
    
    func trim(toCost cost: Int) {
        pthread_mutex_lock(&lock); defer { pthread_mutex_unlock(&lock) }
        _trim(toCost: cost)
    }
    
    func trim(toAge age: TimeInterval) {
        pthread_mutex_lock(&lock); defer { pthread_mutex_unlock(&lock) }
        
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
    
    private func _removeTail(from node: Node) {
        if let prev = node.prev {
            prev.next = nil
            tail = prev
        } else {
            head = nil
            tail = nil
        }
    }
    
    // Private: trim operate
    
    private func _trim(costNeedRemoved: Int, countNeedRemoved: Int) {
        var costTailCount = 0
        var countTailCount = 0
        var lastNode: Node? = tail
        
        repeat {
            guard let node = lastNode else {
                return
            }
            
            costTailCount += node.cost
            countTailCount += 1
            
            storage[node.key] = nil
            
            if costTailCount >= costNeedRemoved && countTailCount >= countNeedRemoved {
                _removeTail(from: node)
                return
            }
            
            lastNode = node.prev
        } while lastNode != nil
    }
    
    private func _trim() {
        if (countLimit == 0 || count <= countLimit) && (costLimit == 0 || costCount <= costLimit) {
            return
        }
        
        let costNeedRemoved = (costLimit == 0 || costCount <= costLimit) ? 0 : costCount - costLimit
        let countNeedRemoved = (countLimit == 0 || count <= countLimit) ? 0 : count - countLimit
        
        _trim(costNeedRemoved: costNeedRemoved, countNeedRemoved: countNeedRemoved)
    }
    
    private func _trim(toCount countLimit: Int) {
        if countLimit >= count {
            return
        }
        
        let countNeedRemoved = count - countLimit
        
        _trim(costNeedRemoved: 0, countNeedRemoved: countNeedRemoved)
    }
    
    private func _trim(toCost costLimit: Int) {
        if costLimit >= costCount {
            return
        }
        
        let costNeedRemoved = costCount - costLimit
        
        _trim(costNeedRemoved: costNeedRemoved, countNeedRemoved: 0)
    }
}
