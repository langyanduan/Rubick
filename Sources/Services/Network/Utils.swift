//
//  Utils.swift
//  Rubick
//
//  Created by wufan on 16/8/31.
//

import Foundation


func query(with parameters: [String: AnyObject]) -> String {
    var components: [(String, String)] = []
    
    for key in parameters.keys.sort(<) {
        let value = parameters[key]!
        
        components += queryComponents(key, value)
    }
    
    return (components.map { "\($0)=\($1)" } as [String]).joinWithSeparator("&")
}


/**
    Creates percent-escaped, URL encoded query string components from the given key-value pair using recursion.

    - parameter key:   The key of the query component.
    - parameter value: The value of the query component.

    - returns: The percent-escaped, URL encoded query string components.
*/
public func queryComponents(key: String, _ value: AnyObject) -> [(String, String)] {
    var components: [(String, String)] = []

    if let dictionary = value as? [String: AnyObject] {
        for (nestedKey, value) in dictionary {
            components += queryComponents("\(key)[\(nestedKey)]", value)
        }
    } else if let array = value as? [AnyObject] {
        for value in array {
            components += queryComponents("\(key)[]", value)
        }
    } else {
        components.append((escape(key), escape("\(value)")))
    }

    return components
}




/**
    Returns a percent-escaped string following RFC 3986 for a query string key or value.

    RFC 3986 states that the following characters are "reserved" characters.

    - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
    - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="

    In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
    query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
    should be percent-escaped in the query string.

    - parameter string: The string to be percent-escaped.

    - returns: The percent-escaped string.
*/
public func escape(string: String) -> String {
    let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
    let subDelimitersToEncode = "!$&'()*+,;="

    let allowedCharacterSet = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as! NSMutableCharacterSet
    allowedCharacterSet.removeCharactersInString(generalDelimitersToEncode + subDelimitersToEncode)

    var escaped = ""

    //==========================================================================================================
    //
    //  Batching is required for escaping due to an internal bug in iOS 8.1 and 8.2. Encoding more than a few
    //  hundred Chinense characters causes various malloc error crashes. To avoid this issue until iOS 8 is no
    //  longer supported, batching MUST be used for encoding. This introduces roughly a 20% overhead. For more
    //  info, please refer to:
    //
    //      - https://github.com/Alamofire/Alamofire/issues/206
    //
    //==========================================================================================================

    if #available(iOS 8.3, OSX 10.10, *) {
        escaped = string.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet) ?? string
    } else {
        let batchSize = 50
        var index = string.startIndex

        while index != string.endIndex {
            let startIndex = index
            let endIndex = index.advancedBy(batchSize, limit: string.endIndex)
            let range = startIndex..<endIndex

            let substring = string.substringWithRange(range)

            escaped += substring.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet) ?? substring

            index = endIndex
        }
    }

    return escaped
}