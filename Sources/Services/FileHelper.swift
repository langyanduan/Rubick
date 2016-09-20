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
    
    private init() {}
    
    private var homeDirectory = NSHomeDirectory() as NSString
    
    public lazy var appBundlePath: String = {
        return Bundle.main.bundlePath
    }()
    
    // Documents/
    public lazy var documentsDirectory: String = {
        return self.homeDirectory.appendingPathComponent("Documents")
    }()
    
    // Library/
    public lazy var libraryDirectory: String = {
        return self.homeDirectory.appendingPathComponent("Library")
    }()
    
    // Library/Application Support/
    public lazy var applicationSupportDirectory: String = {
        return self.homeDirectory.appendingPathComponent("Library/Application Support")
    }()
    
    // Library/Preferences/
    public lazy var preferencesDirectory: String = {
        return self.homeDirectory.appendingPathComponent("Library/Preferences")
    }()
    
    // Library/Caches/
    public lazy var cachesDirectory: String = {
        return self.homeDirectory.appendingPathComponent("Library/Caches")
    }()
    
    // tmp/
    public lazy var temporaryDirectory: String = {
        return self.homeDirectory.appendingPathComponent("Library/tmp")
    }()
    
    
    public lazy var documentsURL: URL = {
        return URL(fileURLWithPath: self.documentsDirectory)
    }()
    
    public lazy var libraryURL: URL = {
        return URL(fileURLWithPath: self.libraryDirectory)
    }()
    
    public lazy var applicationSupportURL: URL = {
        return URL(fileURLWithPath: self.applicationSupportDirectory)
    }()
    
    public lazy var preferencesURL: URL = {
        return URL(fileURLWithPath: self.preferencesDirectory)
    }()
    
    public lazy var cachesURL: URL = {
        return URL(fileURLWithPath: self.cachesDirectory)
    }()
    
    public lazy var temporaryURL: URL = {
        return URL(fileURLWithPath: self.temporaryDirectory)
    }()
    
    
    public func fileExists(atPath path: String) -> Bool {
        return false
    }
    
    public func directoryExists(atPath path: String) -> Bool {
        return false
    }
    
    public func createFile(atPath path: String) -> Bool {
        return false
    }
    
    public func createDirectory(atPath path: String) -> Bool {
        return false
    }
    
    public func removeFile(atPath path: String) -> Bool {
        return false
    }
    
    public func removeDirectory(atPath path: String) -> Bool {
        return false
    }
}

