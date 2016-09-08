//
//  Logger.swift
//  Rubick
//
//  Created by WuFan on 16/9/6.
//
//

import Foundation

open class Logger {
    enum Level {
        case verbose
        case info
        case debug
        case warning
        case error
    }
    public init() {}
    
    open func verbose(_ message: Any, file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        logMessage(.verbose, message: message, file: file, function: function, line: line)
    }
    open func info(_ message: Any, file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        logMessage(.info, message: message, file: file, function: function, line: line)
    }
    open func debug(_ message: Any, file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        logMessage(.debug, message: message, file: file, function: function, line: line)
    }
    open func warning(_ message: Any, file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        logMessage(.warning, message: message, file: file, function: function, line: line)
    }
    open func error(_ message: Any, file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        logMessage(.error, message: message, file: file, function: function, line: line)
    }
    
    func logMessage(_ level: Level, message: Any, file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        
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
    public func LogV(_ message: @autoclosure () -> Any) { }
    public func LogI(_ message: @autoclosure () -> Any) { }
    public func LogD(_ message: @autoclosure () -> Any) { }
    public func LogW(_ message: @autoclosure () -> Any) { }
    public func LogE(_ message: @autoclosure () -> Any) { }
#endif
