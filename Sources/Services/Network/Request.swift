//
//  Request.swift
//  Rubick
//
//  Created by WuFan on 16/9/8.
//
//

import Foundation

class TaskHandler {
    let task: NSURLSessionTask
    let queue: NSOperationQueue = {
        let queue = NSOperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.suspended = true
        queue.qualityOfService = .Utility
        return queue
    }()
    var data: NSData? { return nil }
    var error: NSError?
    
    init(task: NSURLSessionTask) {
        self.task = task
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, needNewBodyStream completionHandler: (NSInputStream?) -> Void) {
        
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        self.error = error
        queue.suspended = false
    }
}

class DataTaskHandler: TaskHandler {
    override var data: NSData? { return mutableData }
    var dataTask: NSURLSessionDataTask? { return task as? NSURLSessionDataTask }
    let mutableData: NSMutableData = NSMutableData()
    
    // NSURLSessionDataDelegate
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        mutableData.appendData(data)
    }
}

class DownloadTaskHandler: TaskHandler {
    var downloadTask: NSURLSessionDownloadTask? { return task as? NSURLSessionDownloadTask }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) { }
    
    func URLSession(
        session: NSURLSession,
        downloadTask: NSURLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64) { }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) { }
}

public class Request {
    let handler: TaskHandler
    
    var task: NSURLSessionTask { return handler.task }
    var request: NSURLRequest? { return task.originalRequest }
    var response: NSHTTPURLResponse? { return task.response as? NSHTTPURLResponse }
    
    init(task: NSURLSessionTask) {
        switch task {
//        case is NSURLSessionUploadTask: fallthrough
        case is NSURLSessionDataTask:
            handler = DataTaskHandler(task: task)
//        case is NSURLSessionDownloadTask:
//            handler = DownloadTaskHandler(task: task)
//        case is NSURLSessionStreamTask: fallthrough
        default:
            assertionFailure()
            handler = TaskHandler(task: task)
        }
    }
    
    public func resume() {
        task.resume()
        Request.postNotification(.DidResume, object: task)
    }
    public func suspend() {
        task.suspend()
        Request.postNotification(.DidSuspend, object: task)
    }
    public func cancel() {
        task.cancel()
        Request.postNotification(.DidCancel, object: task)
    }
}

extension Request: Notifier {
    public enum Notification: String {
        case DidResume
        case DidSuspend
        case DidCancel
        case DidComplete
    }
}

extension Request {
    public func response(queue: dispatch_queue_t? = nil, completionHandler: (NSData?, NSHTTPURLResponse?, NSError?) -> Void) {
        handler.queue.addOperationWithBlock {
            dispatch_async(queue ?? dispatch_get_main_queue()) {
                completionHandler(self.handler.data, self.response, self.handler.error)
            }
        }
    }
}
