//
//  FileHelper.swift
//  Rubick
//
//  Created by WuFan on 16/9/20.
//
//
// see Apple Documention:
// https://developer.apple.com/library/ios/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/FileSystemOverview/FileSystemOverview.html

import Foundation

public class FileHelper {
    public static let shared = FileHelper()
    
    private let homeDirectory: NSString
    private let fileManager: FileManager
    private init() {
        homeDirectory = NSHomeDirectory() as NSString
        fileManager = FileManager()
        
        appBundlePath = Bundle.main.bundlePath
        documentsDirectory = homeDirectory.appendingPathComponent("Documents")
        libraryDirectory = homeDirectory.appendingPathComponent("Library")
        applicationSupportDirectory = homeDirectory.appendingPathComponent("Library/Application Support")
        preferencesDirectory = homeDirectory.appendingPathComponent("Library/Preferences")
        cachesDirectory = homeDirectory.appendingPathComponent("Library/Caches")
        temporaryDirectory = homeDirectory.appendingPathComponent("Library/tmp")
        
        documentsURL = URL(fileURLWithPath: documentsDirectory)
        libraryURL = URL(fileURLWithPath: libraryDirectory)
        applicationSupportURL =  URL(fileURLWithPath: applicationSupportDirectory)
        preferencesURL = URL(fileURLWithPath: preferencesDirectory)
        cachesURL = URL(fileURLWithPath: cachesDirectory)
        temporaryURL = URL(fileURLWithPath: temporaryDirectory)
    }
    
    // App Bundle
    public let appBundlePath: String
    // Documents/
    public let documentsDirectory: String
    // Library/
    public let libraryDirectory: String
    // Library/Application Support/
    public let applicationSupportDirectory: String
    // Library/Preferences/
    public let preferencesDirectory: String
    // Library/Caches/
    public let cachesDirectory: String
    // tmp/
    public let temporaryDirectory: String 
    
    // URL
    public let documentsURL: URL
    public let libraryURL: URL
    public let applicationSupportURL: URL
    public let preferencesURL: URL
    public let cachesURL: URL
    public let temporaryURL: URL
    
    public func fileExists(atPath path: String) -> Bool {
        var isDir: ObjCBool = false
        if (fileManager.fileExists(atPath: path, isDirectory: &isDir)) {
            return !isDir.boolValue
        }
        return false
    }
    
    public func directoryExists(atPath path: String) -> Bool {
        var isDir: ObjCBool = false
        if (fileManager.fileExists(atPath: path, isDirectory: &isDir)) {
            return isDir.boolValue
        }
        return false
    }
    
    @discardableResult
    public func createFile(atPath path: String) -> Bool {
        if fileExists(atPath: path) {
            return true
        }
        do {
            try fileManager.createFile(atPath: path, contents: nil, attributes: nil)
        } catch {
            LogE("FileHelper createFile error: \(error)")
            return false
        }
        return true
    }
    
    @discardableResult
    public func createDirectory(atPath path: String) -> Bool {
        if directoryExists(atPath: path) {
            return true
        }
        do {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            LogE("FileHelper createDirectory error: \(error)")
            return false
        }
        return true
    }
    
    @discardableResult
    public func removeFile(atPath path: String) -> Bool {
        guard fileExists(atPath: path) else {
            LogW("FileHelper removeFile: file not exist")
            return true
        }
        do {
            try fileManager.removeItem(atPath: path)
        } catch  {
            LogE("FileHelper removeFile error: \(error)")
            return false
        }
        return true
    }
    
    @discardableResult
    public func removeDirectory(atPath path: String) -> Bool {
        guard directoryExists(atPath: path) else {
            LogW("FileHelper removeDirectory: directory not exist")
            return true
        }
        do {
            try fileManager.removeItem(atPath: path)
        } catch  {
            LogE("FileHelper removeDirectory error: \(error)")
            return false
        }
        return true
    }
}

