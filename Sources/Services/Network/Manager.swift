//
//  Manager.swift
//  Rubick
//
//  Created by WuFan on 16/9/8.
//
//

import Foundation

class SessionDelegate: NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate {
    class HandlerCollection {
        var collection: [Int: TaskHandler] = [:]
        let queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT)
        
        subscript(task: NSURLSessionTask) -> TaskHandler? {
            get {
                var delegate: TaskHandler?
                dispatch_sync(queue) { delegate = self.collection[task.taskIdentifier] }
                return delegate
            }
            set {
                dispatch_barrier_async(queue) { self.collection[task.taskIdentifier] = newValue }
            }
        }
    }
    
    let taskHandlers = HandlerCollection()
    
    // MARK:- NSURLSessionDelegate
    
    func URLSession(session: NSURLSession, didBecomeInvalidWithError error: NSError?) {
    }
    
    func URLSession(
        session: NSURLSession,
        didReceiveChallenge challenge: NSURLAuthenticationChallenge,
        completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void)
    {
        // TODO: SSL
    }
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
    }
    
    // MARK:- NSURLSessionTaskDelegate
    func URLSession(
        session: NSURLSession,
        task: NSURLSessionTask,
        willPerformHTTPRedirection response: NSHTTPURLResponse,
        newRequest request: NSURLRequest,
        completionHandler: (NSURLRequest?) -> Void)
    {
        completionHandler(request)
    }
    
    func URLSession(
        session: NSURLSession,
        task: NSURLSessionTask,
        didReceiveChallenge challenge: NSURLAuthenticationChallenge,
        completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void)
    {
        // TODO: SSL
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, needNewBodyStream completionHandler: (NSInputStream?) -> Void) {
        if let handler = taskHandlers[task] {
            handler.URLSession(session, task: task, needNewBodyStream: completionHandler)
        }
    }
    
    func URLSession(
        session: NSURLSession,
        task: NSURLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64, totalBytesExpectedToSend: Int64)
    {
        if let hander = taskHandlers[task] {
            hander.URLSession(
                session,
                task: task,
                didSendBodyData: bytesSent,
                totalBytesSent: totalBytesSent,
                totalBytesExpectedToSend: totalBytesExpectedToSend
            )
        }
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if let handler = taskHandlers[task] {
            handler.URLSession(session, task: task, didCompleteWithError: error)
        }
        
        Request.postNotification(.DidComplete, object: task)
        
        taskHandlers[task] = nil
    }
    
    // MARK:- NSURLSessionDataDelegate
    func URLSession(
        session: NSURLSession,
        dataTask: NSURLSessionDataTask,
        didReceiveResponse response: NSURLResponse,
        completionHandler: (NSURLSessionResponseDisposition) -> Void)
    {
        completionHandler(.Allow)
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didBecomeDownloadTask downloadTask: NSURLSessionDownloadTask) {
        // FIXME: never called
        taskHandlers[downloadTask] = DownloadTaskHandler(task: downloadTask)
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        if let handler = taskHandlers[dataTask] as? DataTaskHandler {
            handler.URLSession(session, dataTask: dataTask, didReceiveData: data)
        }
    }
    
    func URLSession(
        session: NSURLSession,
        dataTask: NSURLSessionDataTask,
        willCacheResponse proposedResponse: NSCachedURLResponse,
        completionHandler: (NSCachedURLResponse?) -> Void)
    {
        completionHandler(proposedResponse)
    }
    
    // MARK:- NSURLSessionDownloadDelegate
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        if let handler = taskHandlers[downloadTask] as? DownloadTaskHandler {
            handler.URLSession(session, downloadTask: downloadTask, didFinishDownloadingToURL: location)
        }
    }
    
    func URLSession(
        session: NSURLSession,
        downloadTask: NSURLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64)
    {
        if let handler = taskHandlers[downloadTask] as? DownloadTaskHandler {
            handler.URLSession(
                session,
                downloadTask: downloadTask,
                didWriteData: bytesWritten,
                totalBytesWritten: totalBytesWritten,
                totalBytesExpectedToWrite: totalBytesExpectedToWrite
            )
        }
    }
    
    func URLSession(
        session: NSURLSession,
        downloadTask: NSURLSessionDownloadTask,
        didResumeAtOffset fileOffset: Int64,
        expectedTotalBytes: Int64)
    {
        if let handler = taskHandlers[downloadTask] as? DownloadTaskHandler {
            handler.URLSession(session, downloadTask: downloadTask, didResumeAtOffset: fileOffset, expectedTotalBytes: expectedTotalBytes)
        }
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
        sessionDelegate.taskHandlers[dataTask] = request.handler
        if startRequestsImmediately {
            request.resume()
        }
        
        return request
    }
}

//extension Manager {
//    func download(URLRequest: NSURLRequest) { }
//    func upload(URLRequest: NSURLRequest) { }
//}

