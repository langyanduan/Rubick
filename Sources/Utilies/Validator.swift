//
//  Validator.swift
//  Rubick
//
//  Created by WuFan on 2016/9/29.
//
//

import Foundation

private struct Expression {
    static let number = "^[0-9]+$"
    static let letter = "^[a-zA-Z]+$"
    static let chinese = "^[\\u4e00-\\u9fa5]+$"
    static let email = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$"
    static let phoneNumber = "^(13[0-9]|14[57]|15[012356789]|17[0678]|18[0-9])[0-9]{8}$"
    static let identifier = "^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X|x)$"
//    static let url = "^(http://|https://|www.)((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*)|([-_#^?'+!&%.@=*]))+((\\w)*|([0-9]*|([-_#^?'+!&%.@=*])))+$"
}

extension InstanceExtension where Base: _StringType {
    private var _self: String {
        return base as! String
    }

    private func validator(candidate: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", candidate).evaluate(with: _self)
    }
    
    /// 是否是纯数字
    public var isNumber: Bool {
        return validator(candidate: Expression.number)
    }
    
    /// 是否是邮箱地址
    public var isEmail: Bool {
        return validator(candidate: Expression.email)
    }
    
    /// 是否是手机号码
    public var isPhoneNumber: Bool {
        return validator(candidate: Expression.phoneNumber)
    }
    
    /// 是否是身份证号
    public var isIdentifier: Bool {
        return validator(candidate: Expression.identifier)
    }
    
    /// 是否是纯字母
    public var isLetter: Bool {
        return validator(candidate: Expression.letter)
    }
    
    /// 是否是纯中文
    public var isChinese: Bool {
        return validator(candidate: Expression.chinese)
    }
    
//    public var isURL: Bool {
//        return URL(string: _self) != nil
//    }
}
