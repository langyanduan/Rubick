//
//  Request.swift
//  Rubick
//
//  Created by WuFan on 16/9/8.
//
//

import Foundation

class TaskHandler {
    let task: URLSessionTask
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.isSuspended = true
        queue.qualityOfService = .utility
        return queue
    }()
    var data: Data? { return nil }
    var error: Error?
    
    init(task: URLSessionTask) {
        self.task = task
    }
    
    func urlSession(_ session: Foundation.URLSession, task: URLSessionTask, needNewBodyStream completionHandler: (InputStream?) -> Void) {
        
    }
    
    func urlSession(_ session: Foundation.URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
    }
    
    func urlSession(_ session: Foundation.URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        self.error = error
        queue.isSuspended = false
    }
}

class DataTaskHandler: TaskHandler {
    override var data: Data? { return mutableData as Data }
    var dataTask: URLSessionDataTask? { return task as? URLSessionDataTask }
    var mutableData: Data = Data()
    
    // NSURLSessionDataDelegate
    func urlSession(_ session: Foundation.URLSession, dataTask: URLSessionDataTask, didReceiveData data: Data) {
        mutableData.append(data)
    }
}

class DownloadTaskHandler: TaskHandler {
    var downloadTask: URLSessionDownloadTask? { return task as? URLSessionDownloadTask }
    
    func urlSession(_ session: Foundation.URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingToURL location: URL) { }
    
    func urlSession(
        _ session: Foundation.URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64) { }
    
    func urlSession(_ session: Foundation.URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) { }
}

open class Request {
    let handler: TaskHandler
    
    var task: URLSessionTask { return handler.task }
    var request: URLRequest? { return task.originalRequest }
    var response: HTTPURLResponse? { return task.response as? HTTPURLResponse }
    
    init(task: URLSessionTask) {
        switch task {
//        case is NSURLSessionUploadTask: fallthrough
        case is URLSessionDataTask:
            handler = DataTaskHandler(task: task)
//        case is NSURLSessionDownloadTask:
//            handler = DownloadTaskHandler(task: task)
//        case is NSURLSessionStreamTask: fallthrough
        default:
            assertionFailure()
            handler = TaskHandler(task: task)
        }
    }
    
    open func resume() {
        task.resume()
        Request.post(notification: .DidResume, object: task)
    }
    open func suspend() {
        task.suspend()
        Request.post(notification: .DidSuspend, object: task)
    }
    open func cancel() {
        task.cancel()
        Request.post(notification: .DidCancel, object: task)
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
    public func response(_ queue: DispatchQueue = DispatchQueue.main, completionHandler: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        handler.queue.addOperation {
            queue.async {
                completionHandler(self.handler.data, self.response, self.handler.error)
            }
        }
    }
}
