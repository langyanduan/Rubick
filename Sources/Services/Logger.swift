//
//  Logger.swift
//  Rubick
//
//  Created by WuFan on 16/9/6.
//
//

import Foundation

public final class Logger {
    enum Level {
        case verbose
        case info
        case debug
        case warning
        case error
    }
    public init() {}
    
    public func verbose(_ message: Any, file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        logMessage(.verbose, message: message, file: file, function: function, line: line)
    }
    public func info(_ message: Any, file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        logMessage(.info, message: message, file: file, function: function, line: line)
    }
    public func debug(_ message: Any, file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        logMessage(.debug, message: message, file: file, function: function, line: line)
    }
    public func warning(_ message: Any, file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        logMessage(.warning, message: message, file: file, function: function, line: line)
    }
    public func error(_ message: Any, file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        logMessage(.error, message: message, file: file, function: function, line: line)
    }
    
    func logMessage(_ level: Level, message: Any, file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        print(message)
    }
}


#if DEBUG
    private let logger = Logger()
    
    func LogV(_ message: Any, file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        logger.verbose(message, file: file, function: function, line: line)
    }
    func LogI(_ message: Any, file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        logger.info(message, file: file, function: function, line: line)
    }
    func LogD(_ message: Any, file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        logger.debug(message, file: file, function: function, line: line)
    }
    func LogW(_ message: Any, file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        logger.warning(message, file: file, function: function, line: line)
    }
    func LogE(_ message: Any, file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        logger.error(message, file: file, function: function, line: line)
    }
#else
    func LogV(_ message: @autoclosure () -> Any) { }
    func LogI(_ message: @autoclosure () -> Any) { }
    func LogD(_ message: @autoclosure () -> Any) { }
    func LogW(_ message: @autoclosure () -> Any) { }
    func LogE(_ message: @autoclosure () -> Any) { }
#endif
