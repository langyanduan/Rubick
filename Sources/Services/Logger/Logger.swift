//
//  Logger.swift
//  Rubick
//
//  Created by WuFan on 16/9/6.
//
//

import Foundation

private let loggerQueue = DispatchQueue(label: "com.rubick.logger", qos: DispatchQoS.default, attributes: DispatchQueue.Attributes.concurrent)

public enum LoggerLevel: Int {
    case verbose
    case info
    case debug
    case warning
    case error
    
    var text: String {
        switch self {
        case .verbose:
            return "Verbose"
        case .info:
            return "Info"
        case .debug:
            return "Debug"
        case .warning:
            return "Warning"
        case .error:
            return "Error"
        }
    }
}

extension LoggerLevel: Comparable {
    public static func <(lhs: LoggerLevel, rhs: LoggerLevel) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    public static func ==(lhs: LoggerLevel, rhs: LoggerLevel) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

public protocol DestinationProtocol {
    func build(level: LoggerLevel,
               date: Date,
               threadLabel: String,
               fileName: String,
               functionName: String,
               lineNumber: Int) -> String
    func write(level: LoggerLevel, info: String, message: String)
    
    var outputLevel: LoggerLevel { get }
    var async: Bool { get }
}

public class BaseDestination {
    var formatter = DateFormatter().then { (formatter) in
        formatter.dateFormat = "MM-dd HH:mm:ss"
    }
    
    public var showLevel = true
    public var showFileName = true
    public var showLineNumber = true
    public var showFunctionName = true
    public var showThreadLabel = true
    public var showDate = true
    public var dateFormat: String = "MM-dd HH:mm:ss" {
        didSet { formatter.dateFormat = dateFormat }
    }
    public var outputLevel: LoggerLevel = .verbose
    public var async = false
    
    fileprivate init() { }
    
    public func build(level: LoggerLevel,
                      date: Date,
                      threadLabel: String,
                      fileName: String,
                      functionName: String,
                      lineNumber: Int) -> String
    {
        var list: [String] = []
        
        if showDate { list.append(formatter.string(from: date)) }
        if showLevel { list.append("[\(level.text)]") }
        if showThreadLabel { list.append("[\(threadLabel)]") }
        
        let postition: String?
        do {
            var text = ""
            if showFileName { text += "\(fileName)" }
            if showLineNumber { text += ":\(lineNumber)" }
            if showFunctionName { text += " \(functionName)" }
            postition = text.isEmpty ? nil : "[\(text)]"
        }
        if let postition = postition { list.append(postition) }
        
        return list.joined(separator: " ")
    }
    
}

public class FileDestination: BaseDestination, DestinationProtocol {
    public override init() {
        super.init()
    }
    public func write(level: LoggerLevel, info: String, message: String) {
        
    }
}

public class ConsoleDestination: BaseDestination, DestinationProtocol {
    
    public let escape: String = "\u{001b}["
    
    public var verboseColorText: String = "fg102,102,102;"
    public var infoColorText: String = "fg153,153,153;"
    public var debugColorText: String = "fg0,153,0;"
    public var warningColorText: String = "fg211,119,34;"
    public var errorColorText: String = "fg204,0,0;"
    
    public var colorful = true
    public var useNSLog = false
    
    public override init() {
       super.init()
    }
    
    public func set(color: UIColor, for level: LoggerLevel) {
        switch level {
        case .verbose:
            verboseColorText = color.fgColorText()
        case .info:
            infoColorText = color.fgColorText()
        case .debug:
            debugColorText = color.fgColorText()
        case .warning:
            warningColorText = color.fgColorText()
        case .error:
            errorColorText = color.fgColorText()
        }
    }
    
    public func write(level: LoggerLevel, info: String, message: String) {
        var processedMessage: String
        if colorful {
            switch level {
            case .verbose:
                processedMessage = verboseColorText
            case .info:
                processedMessage = infoColorText
            case .debug:
                processedMessage = debugColorText
            case .warning:
                processedMessage = warningColorText
            case .error:
                processedMessage = errorColorText
            }
            
            if !info.isEmpty {
                processedMessage = "\(escape)fg50,50,50;" + info + "\(escape);" + " 💊 " + "\(escape)" + processedMessage + message + "\(escape);"
            } else {
                processedMessage = "\(escape)" + processedMessage + message + "\(escape);"
            }
        } else {
            if !info.isEmpty {
                processedMessage = info + " 💊 " + message
            } else {
                processedMessage = message
            }
        }
        
        if useNSLog {
            NSLog(processedMessage)
        } else {
            print(processedMessage)
        }
    }
}

public class NetworkDestination: BaseDestination, DestinationProtocol {
    public let address: String
    public let port: Int
    
    public init(address: String, port: Int) {
        self.address = address
        self.port = port
        super.init()
    }
    
    public func write(level: LoggerLevel, info: String, message: String) {
        
    }
}

public final class Logger {
    
    private var destinations: [DestinationProtocol] = []
    
    public init() {}
    
    public func add(_ destination: DestinationProtocol) {
        self.destinations.append(destination)
    }
    
    public func verbose(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        output(.verbose, message: message, file: file, function: function, line: line)
    }
    public func info(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        output(.info, message: message, file: file, function: function, line: line)
    }
    public func debug(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        output(.debug, message: message, file: file, function: function, line: line)
    }
    public func warning(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        output(.warning, message: message, file: file, function: function, line: line)
    }
    public func error(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        output(.error, message: message, file: file, function: function, line: line)
    }
    
    func output(_ level: LoggerLevel, message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        let message = "\(message)"
        let threadLabel: String
        if Thread.isMainThread {
            threadLabel = "main"
        } else if let threadName = Thread.current.name, !threadName.isEmpty {
            threadLabel = threadName
        } else if let queueName = DispatchQueue.currentQueueLabel, !queueName.isEmpty {
            threadLabel = queueName
        } else {
            threadLabel = String(format: "%p", Thread.current)
        }
        let date = Date()
        let fileName: String = file.ext.lastPathComponent
        
        for dest in destinations {
            if level < dest.outputLevel {
                continue
            }
            
            let code: () -> () = {
                let info = dest.build(level: level,
                                      date: date,
                                      threadLabel: threadLabel,
                                      fileName: fileName,
                                      functionName: function,
                                      lineNumber: line)
                dest.write(level: level, info: info, message: message)
            }
            
            if dest.async {
                loggerQueue.async {
                    code()
                }
            } else {
                code()
            }
            
        }
    }
}

extension UIColor {
    fileprivate convenience init(red: UInt8, green: UInt8, blue: UInt8) {
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1)
    }
    
    fileprivate func fgColorText() -> String {
        let componets = UIColorGetComponents(self)
        let r = Int(componets[0] * 255)
        let g = Int(componets[1] * 255)
        let b = Int(componets[2] * 255)
        return "fg\(r),\(g),\(b);"
    }
}

#if DEBUG
    private let logger: Logger = {
        let logger = Logger()
        let console = ConsoleDestination()
        logger.add(console)
        return logger
    }()
    
    func LogV(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        logger.verbose(message, file: file, function: function, line: line)
    }
    func LogI(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        logger.info(message, file: file, function: function, line: line)
    }
    func LogD(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        logger.debug(message, file: file, function: function, line: line)
    }
    func LogW(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        logger.warning(message, file: file, function: function, line: line)
    }
    func LogE(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        logger.error(message, file: file, function: function, line: line)
    }
#else
    func LogV(_ message: @autoclosure () -> Any) { }
    func LogI(_ message: @autoclosure () -> Any) { }
    func LogD(_ message: @autoclosure () -> Any) { }
    func LogW(_ message: @autoclosure () -> Any) { }
    func LogE(_ message: @autoclosure () -> Any) { }
#endif
