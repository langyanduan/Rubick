//
//  EmptyPlaceholder.swift
//  Rubick
//
//  Created by WuFan on 16/9/10.
//
//

import Foundation

private var ConfigurationKey: Void = ()

private class TableView: UITableView {
    var configuration: PlaceholderConfiguration {
        if let value = objc_getAssociatedObject(self, &ConfigurationKey) as? PlaceholderConfiguration {
            return value
        }
        let value = PlaceholderConfiguration()
        objc_setAssociatedObject(self, &ConfigurationKey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return value
    }
    
    override var frame: CGRect {
        get { return super.frame }
        set {
            super.frame = newValue
        }
    }
    
    override var bounds: CGRect {
        get { return super.bounds }
        set {
            super.bounds = newValue
        }
    }
    
    override func reloadData() {
        super.reloadData()
    }
}

public class PlaceholderConfiguration {
    var visible: Bool = false
    
    
    var textConfigure: ((Void) -> String?)?
    var imageConfigure: ((Void) -> UIImage?)?
    
    @discardableResult
    public func configureText(_ closure: @escaping (Void) -> String?) -> Self {
        textConfigure = closure
        return self
    }
    
    @discardableResult
    public func configureImage(_ closure: @escaping (Void) -> UIImage?) -> Self {
        imageConfigure = closure
        return self
    }
    
    public var a: Int = 5
}

extension InstanceExtension where Base: UITableView {
    
    public var placeholder: PlaceholderConfiguration {
        assertMainThread()
        
        if let tv = base as? TableView {
            return tv.configuration
        }
        assert(object_getClass(base) == UITableView.self)
        object_setClass(base, TableView.self)
        
        return (base as! TableView).configuration
    }
}

