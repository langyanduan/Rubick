//
//  Logger.swift
//  Rubick
//
//  Created by WuFan on 16/9/6.
//
//

import Foundation

public class Logger {
    enum Level {
        case Verbose
        case Info
        case Debug
        case Warning
        case Error
    }
    public init() {}
    
    public func verbose(message: Any, file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        logMessage(.Verbose, message: message, file: file, function: function, line: line)
    }
    public func info(message: Any, file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        logMessage(.Info, message: message, file: file, function: function, line: line)
    }
    public func debug(message: Any, file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        logMessage(.Debug, message: message, file: file, function: function, line: line)
    }
    public func warning(message: Any, file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        logMessage(.Warning, message: message, file: file, function: function, line: line)
    }
    public func error(message: Any, file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        logMessage(.Error, message: message, file: file, function: function, line: line)
    }
    
    func logMessage(level: Level, message: Any, file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        
    }
}


#if DEBUG
    private let logger = Logger()
    
    public func LogV(message: Any, file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        logger.verbose(message, file: file, function: function, line: line)
    }
    public func LogI(message: Any, file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        logger.info(message, file: file, function: function, line: line)
    }
    public func LogD(message: Any, file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        logger.debug(message, file: file, function: function, line: line)
    }
    public func LogW(message: Any, file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        logger.warning(message, file: file, function: function, line: line)
    }
    public func LogE(message: Any, file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        logger.error(message, file: file, function: function, line: line)
    }
#else
    public func LogV(@autoclosure message: () -> Any) { }
    public func LogI(@autoclosure message: () -> Any) { }
    public func LogD(@autoclosure message: () -> Any) { }
    public func LogW(@autoclosure message: () -> Any) { }
    public func LogE(@autoclosure message: () -> Any) { }
#endif
