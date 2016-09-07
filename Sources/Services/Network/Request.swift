//
//  Request.swift
//  Connect
//
//  Created by WuFan on 16/9/7.
//  Copyright © 2016年 dacai. All rights reserved.
//

import Foundation

class Network: Notifier {
    enum Notification: String {
        case DidResume
        case DidSuspend
        case DidCancel
        case DidComplete
    }
}

class TaskHandler {
    let task: NSURLSessionTask
    let queue: NSOperationQueue
    var data: NSData? { return nil }
    var error: NSError?
    
    init(task: NSURLSessionTask) {
        self.task = task
        
        queue = NSOperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.suspended = true
        queue.qualityOfService = .Utility
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, needNewBodyStream completionHandler: (NSInputStream?) -> Void) {
        
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        queue.suspended = false
        Network.postNotificationName(.DidComplete, object: task)
    }
    
    deinit {
        print("deinit")
    }
}

class DataTaskHandler: TaskHandler {
    var dataTask: NSURLSessionDataTask? { return task as? NSURLSessionDataTask }
    override var data: NSData? {
        return mutableData
    }
    let mutableData: NSMutableData = NSMutableData()
    // NSURLSessionDataDelegate
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        mutableData.appendData(data)
        
        LogD()
    }
}

class DownloadTaskHandler: TaskHandler {
    var downloadTask: NSURLSessionDownloadTask? { return task as? NSURLSessionDownloadTask }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        
    }
}





public class Request {
    let handler: TaskHandler
    
    var task: NSURLSessionTask { return handler.task }
    var request: NSURLRequest? { return task.originalRequest }
    var response: NSHTTPURLResponse? { return task.response as? NSHTTPURLResponse }
    
    init(task: NSURLSessionTask) {
        switch task {
        case is NSURLSessionDataTask:
            handler = DataTaskHandler(task: task)
        case is NSURLSessionDownloadTask:
            handler = DownloadTaskHandler(task: task)
//        case is NSURLSessionUploadTask: fallthrough
//        case is NSURLSessionStreamTask: fallthrough
        default:
            handler = TaskHandler(task: task)
        }
        
    }
    
    
    public func resume() {
        task.resume()
        Network.postNotificationName(.DidResume, object: task)
    }
    public func suspend() {
        task.suspend()
        Network.postNotificationName(.DidSuspend, object: task)
    }
    public func cancel() {
        task.cancel()
        Network.postNotificationName(.DidCancel, object: task)
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
