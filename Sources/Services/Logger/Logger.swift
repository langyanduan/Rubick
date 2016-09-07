//
//  Logger.swift
//  Rubick
//
//  Created by WuFan on 16/9/6.
//
//

import Foundation

#if DEBUG

    public func LogV(message: String, file: String = #file, function: String = #function, line: Int = #line) {
        Logger(message, level: .Verbose, file: file, function: function, line: line)
    }

    public func LogI(message: String, file: String = #file, function: String = #function, line: Int = #line) {
        Logger(message, level: .Information, file: file, function: function, line: line)
    }

    public func LogD(message: String, file: String = #file, function: String = #function, line: Int = #line) {
        Logger(message, level: .Debug, file: file, function: function, line: line)
    }

    public func LogW(message: String, file: String = #file, function: String = #function, line: Int = #line) {
        Logger(message, level: .Warning, file: file, function: function, line: line)
    }

    public func LogE(message: String, file: String = #file, function: String = #function, line: Int = #line) {
        Logger(message, level: .Error, file: file, function: function, line: line)
    }
    
#else
    
    public func LogV(@autoclosure message: () -> String) { }

    public func LogI(@autoclosure message: () -> String) { }

    public func LogD(@autoclosure message: () -> String) { }

    public func LogW(@autoclosure message: () -> String) { }

    public func LogE(@autoclosure message: () -> String) { }
    
#endif

private enum LoggerLevel {
    case Verbose
    case Information
    case Debug
    case Warning
    case Error
}

private func Logger(message: String, level: LoggerLevel, file: String, function: String, line: Int) {
    print(message)
}
