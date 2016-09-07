//
//  Manager.swift
//  Connect
//
//  Created by WuFan on 16/9/6.
//  Copyright © 2016年 dacai. All rights reserved.
//

import Foundation

func LogD(function: String = #function, _ file: String = #file, _ line: Int = #line) {
    print("\(file), \(function), \(line)")
}


class SessionDelegate: NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate {
    var taskHandlers: [Int: TaskHandler] = [:]
    var taskHandlerQueue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT)
    
    subscript(task: NSURLSessionTask) -> TaskHandler? {
        get {
            var delegate: TaskHandler?
            dispatch_sync(taskHandlerQueue) { delegate = self.taskHandlers[task.taskIdentifier] }
            return delegate
        }
        set {
            dispatch_barrier_async(taskHandlerQueue) { self.taskHandlers[task.taskIdentifier] = newValue }
        }
    }
    
    
    // MARK:- NSURLSessionDelegate
    
    func URLSession(session: NSURLSession, didBecomeInvalidWithError error: NSError?) {
        LogD()
    }
    
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        // TODO: SSL
        LogD()
    }
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        
        LogD()
    }
    
    // MARK:- NSURLSessionTaskDelegate
    func URLSession(session: NSURLSession, task: NSURLSessionTask, willPerformHTTPRedirection response: NSHTTPURLResponse, newRequest request: NSURLRequest, completionHandler: (NSURLRequest?) -> Void) {
        completionHandler(request)
        LogD()
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        // TODO: SSL
        LogD()
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, needNewBodyStream completionHandler: (NSInputStream?) -> Void) {
        if let handler = self[task] {
            handler.URLSession(session, task: task, needNewBodyStream: completionHandler)
        }
        LogD()
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        if let hander = self[task] {
            hander.URLSession(session, task: task, didSendBodyData: bytesSent, totalBytesSent: totalBytesSent, totalBytesExpectedToSend: totalBytesExpectedToSend)
        }
        LogD()
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if let handler = self[task] {
            handler.URLSession(session, task: task, didCompleteWithError: error)
        }
        
        self[task] = nil
        LogD()
    }
    
    // MARK:- NSURLSessionDataDelegate
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        completionHandler(.Allow)
        
        LogD()
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didBecomeDownloadTask downloadTask: NSURLSessionDownloadTask) {
        self[downloadTask] = DownloadTaskHandler(task: downloadTask)
        
        
        
        
        
        
        LogD()
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        if let handler = self[dataTask] as? DataTaskHandler {
            handler.URLSession(session, dataTask: dataTask, didReceiveData: data)
        }
        LogD()
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, willCacheResponse proposedResponse: NSCachedURLResponse, completionHandler: (NSCachedURLResponse?) -> Void) {
        completionHandler(proposedResponse)
        LogD()
    }
    
    // MARK:- NSURLSessionDownloadDelegate
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        if let handler = self[downloadTask] as? DownloadTaskHandler {
            handler.URLSession(session, downloadTask: downloadTask, didFinishDownloadingToURL: location)
        }
        LogD()
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if let handler = self[downloadTask] as? DownloadTaskHandler {
            handler.URLSession(session, downloadTask: downloadTask, didWriteData: bytesWritten, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
        }
        LogD()
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        if let handler = self[downloadTask] as? DownloadTaskHandler {
            handler.URLSession(session, downloadTask: downloadTask, didResumeAtOffset: fileOffset, expectedTotalBytes: expectedTotalBytes)
        }
        LogD()
    }
}

public class Manager {
    let sessionDelegate: SessionDelegate
    let session: NSURLSession
    let createQueue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL)
    
    var startRequestsImmediately: Bool = true
    
    public init(configuration: NSURLSessionConfiguration = .defaultSessionConfiguration()) {
        sessionDelegate = SessionDelegate()
        session = NSURLSession(configuration: configuration, delegate: sessionDelegate, delegateQueue: nil)
    }
    
    deinit {
        session.invalidateAndCancel()
    }
    
    public func sendRequest(URLRequest: NSURLRequest) -> Request {
        var dataTask: NSURLSessionDataTask!
        dispatch_sync(createQueue) {
            dataTask = self.session.dataTaskWithRequest(URLRequest)
        }
        let request = Request(task: dataTask)
        sessionDelegate[dataTask] = request.handler
        if startRequestsImmediately {
            request.resume()
        }
        
        return request
    }
    
    func download(URLRequest: NSURLRequest) { }
    func upload(URLRequest: NSURLRequest) { }
}

extension Manager {
    
    
}

