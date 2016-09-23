//
//  Manager.swift
//  Rubick
//
//  Created by WuFan on 16/9/8.
//
//

import Foundation

class SessionDelegate: NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate, URLSessionDownloadDelegate {
    class HandlerCollection {
        var collection: [Int: TaskHandler] = [:]
        let queue = DispatchQueue(label: "HandlerAccessor", attributes: DispatchQueue.Attributes.concurrent)
        
        subscript(task: URLSessionTask) -> TaskHandler? {
            get {
                var delegate: TaskHandler?
                queue.sync { delegate = self.collection[task.taskIdentifier] }
                return delegate
            }
            set {
                queue.async(flags: .barrier) { self.collection[task.taskIdentifier] = newValue }
            }
        }
    }
    
    let taskHandlers = HandlerCollection()
    
    // MARK:- NSURLSessionDelegate
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
    }
    
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        // TODO: SSL
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
    }
    
    // MARK:- NSURLSessionTaskDelegate
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        willPerformHTTPRedirection response: HTTPURLResponse,
        newRequest request: URLRequest,
        completionHandler: @escaping (URLRequest?) -> Void)
    {
        completionHandler(request)
    }
    
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        // TODO: SSL
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Void) {
        if let handler = taskHandlers[task] {
            handler.urlSession(session, task: task, needNewBodyStream: completionHandler)
        }
    }
    
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64, totalBytesExpectedToSend: Int64)
    {
        if let hander = taskHandlers[task] {
            hander.urlSession(
                session,
                task: task,
                didSendBodyData: bytesSent,
                totalBytesSent: totalBytesSent,
                totalBytesExpectedToSend: totalBytesExpectedToSend
            )
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let handler = taskHandlers[task] {
            handler.urlSession(session, task: task, didCompleteWithError: error)
        }
        
        Request.post(notification: .didComplete, object: task)
        
        taskHandlers[task] = nil
    }
    
    // MARK:- NSURLSessionDataDelegate
    func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive response: URLResponse,
        completionHandler: @escaping (URLSession.ResponseDisposition) -> Void)
    {
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
        // FIXME: never called
        taskHandlers[downloadTask] = DownloadTaskHandler(task: downloadTask)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let handler = taskHandlers[dataTask] as? DataTaskHandler {
            handler.urlSession(session, dataTask: dataTask, didReceiveData: data)
        }
    }
    
    func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        willCacheResponse proposedResponse: CachedURLResponse,
        completionHandler: @escaping (CachedURLResponse?) -> Void)
    {
        completionHandler(proposedResponse)
    }
    
    // MARK:- NSURLSessionDownloadDelegate
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let handler = taskHandlers[downloadTask] as? DownloadTaskHandler {
            handler.urlSession(session, downloadTask: downloadTask, didFinishDownloadingToURL: location)
        }
    }
    
    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64)
    {
        if let handler = taskHandlers[downloadTask] as? DownloadTaskHandler {
            handler.urlSession(
                session,
                downloadTask: downloadTask,
                didWriteData: bytesWritten,
                totalBytesWritten: totalBytesWritten,
                totalBytesExpectedToWrite: totalBytesExpectedToWrite
            )
        }
    }
    
    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didResumeAtOffset fileOffset: Int64,
        expectedTotalBytes: Int64)
    {
        if let handler = taskHandlers[downloadTask] as? DownloadTaskHandler {
            handler.urlSession(session, downloadTask: downloadTask, didResumeAtOffset: fileOffset, expectedTotalBytes: expectedTotalBytes)
        }
    }
}

public final class Manager {
    let sessionDelegate: SessionDelegate
    let session: URLSession
    let createQueue = DispatchQueue(label: "CreateTask", attributes: [])
    
    public var startRequestsImmediately: Bool = true
    
    public init(configuration: URLSessionConfiguration = .default) {
        sessionDelegate = SessionDelegate()
        session = URLSession(configuration: configuration, delegate: sessionDelegate, delegateQueue: nil)
    }
    
    deinit {
        session.invalidateAndCancel()
    }
    
    public func sendRequest(_ urlRequest: URLRequest) -> Request {
        var dataTask: URLSessionDataTask!
        createQueue.sync {
            dataTask = self.session.dataTask(with: urlRequest)
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


extension Manager: Then { }
