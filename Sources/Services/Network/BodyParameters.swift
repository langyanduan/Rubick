//
//  BodyParameters.swift
//  Rubick
//
//  Created by WuFan on 16/9/8.
//
//

import Foundation

public enum RequestBody {
    case data(Foundation.Data)
    case inputStream(Foundation.InputStream)
}

public protocol BodyParametersType {
    var contentType: String { get }
    func buildBody() throws -> RequestBody
}

public struct JSONParameters: BodyParametersType {
    var parameters: [String: AnyObject]
    
    public init(parameters: [String: AnyObject]) {
        self.parameters = parameters
    }
    
    public var contentType: String {
        return "application/json"
    }
    
    public func buildBody() throws -> RequestBody {
        do {
            return .data(try JSONSerialization.data(withJSONObject: parameters, options: []))
        } catch {
            throw HTTPError.encoding
        }
    }
}

extension NSNumber {
    fileprivate var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}


public struct FormURLParameters: BodyParametersType {
    var parameters: [String: Any]
    
    public init(parameters: [String: Any]) {
        self.parameters = parameters
    }
    
    public var contentType: String {
        return "application/x-www-form-urlencoded"
    }
    
    public func buildBody() throws -> RequestBody {
        return .data(FormURLParameters.query(parameters).data(using: .utf8)!)
    }
    
    static func query(_ parameters: [String: Any]) -> String {
        
        /// Creates percent-escaped, URL encoded query string components from the given key-value pair using recursion.
        ///
        /// - parameter key:   The key of the query component.
        /// - parameter value: The value of the query component.
        ///
        /// - returns: The percent-escaped, URL encoded query string components.
        func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
            var components: [(String, String)] = []
            
            if let dictionary = value as? [String: Any] {
                for (nestedKey, value) in dictionary {
                    components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
                }
            } else if let array = value as? [Any] {
                for value in array {
                    components += queryComponents(fromKey: "\(key)[]", value: value)
                }
            } else if let value = value as? NSNumber {
                if value.isBool {
                    components.append((escape(key), escape((value.boolValue ? "1" : "0"))))
                } else {
                    components.append((escape(key), escape("\(value)")))
                }
            } else if let bool = value as? Bool {
                components.append((escape(key), escape((bool ? "1" : "0"))))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
            
            return components
        }
        
        /// Returns a percent-escaped string following RFC 3986 for a query string key or value.
        ///
        /// RFC 3986 states that the following characters are "reserved" characters.
        ///
        /// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
        /// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
        ///
        /// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
        /// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
        /// should be percent-escaped in the query string.
        ///
        /// - parameter string: The string to be percent-escaped.
        ///
        /// - returns: The percent-escaped string.
        func escape(_ string: String) -> String {
            let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
            let subDelimitersToEncode = "!$&'()*+,;="
            
            var allowedCharacterSet = CharacterSet.urlQueryAllowed
            allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
            
            return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        }
        
        func query(_ parameters: [String: Any]) -> String {
            var components: [(String, String)] = []
            
            for key in parameters.keys.sorted(by: <) {
                let value = parameters[key]!
                components += queryComponents(fromKey: key, value: value)
            }
            
            return components.map { "\($0)=\($1)" }.joined(separator: "&")
        }
        
        return query(parameters)
    }
}
