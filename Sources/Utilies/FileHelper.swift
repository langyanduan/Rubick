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
    
    // lazy
    public lazy var appBundlePath: String = Bundle.main.bundlePath
    
    // Documents/
    public lazy var documentsDirectory: String = self.homeDirectory.appendingPathComponent("Documents")
    
    // Library/
    public lazy var libraryDirectory: String = self.homeDirectory.appendingPathComponent("Library")
    
    // Library/Application Support/
    public lazy var applicationSupportDirectory: String = self.homeDirectory.appendingPathComponent("Library/Application Support")
    
    // Library/Preferences/
    public lazy var preferencesDirectory: String = self.homeDirectory.appendingPathComponent("Library/Preferences")
    
    // Library/Caches/
    public lazy var cachesDirectory: String = self.homeDirectory.appendingPathComponent("Library/Caches")
    
    // tmp/
    public lazy var temporaryDirectory: String = self.homeDirectory.appendingPathComponent("Library/tmp")
    
    // URL
    public lazy var documentsURL: URL = URL(fileURLWithPath: self.documentsDirectory)
    public lazy var libraryURL: URL = URL(fileURLWithPath: self.libraryDirectory)
    public lazy var applicationSupportURL: URL =  URL(fileURLWithPath: self.applicationSupportDirectory)
    public lazy var preferencesURL: URL = URL(fileURLWithPath: self.preferencesDirectory)
    public lazy var cachesURL: URL = URL(fileURLWithPath: self.cachesDirectory)
    public lazy var temporaryURL: URL = URL(fileURLWithPath: self.temporaryDirectory)
    
    
    public func fileExists(atPath path: String) -> Bool {
        return false
    }
    
    public func directoryExists(atPath path: String) -> Bool {
        return false
    }
    
    @discardableResult
    public func createFile(atPath path: String) -> Bool {
        return false
    }
    
    @discardableResult
    public func createDirectory(atPath path: String) -> Bool {
        return false
    }
    
    @discardableResult
    public func removeFile(atPath path: String) -> Bool {
        return false
    }
    
    @discardableResult
    public func removeDirectory(atPath path: String) -> Bool {
        return false
    }
}

