//
//  TaskHandler.swift
//  Rubick
//
//  Created by WuFan on 16/9/25.
//
//

import Foundation

class TaskHandler {
    let task: URLSessionTask
    let queue: OperationQueue = OperationQueue().then { queue in
        queue.maxConcurrentOperationCount = 1
        queue.isSuspended = true
        queue.qualityOfService = .utility
    }
    var data: Data? { return nil }
    var error: Error?
    
    init(task: URLSessionTask) {
        self.task = task
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: (InputStream?) -> Void) {
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        self.error = error
        queue.isSuspended = false
    }
}

class DataTaskHandler: TaskHandler {
    override var data: Data? { return mutableData as Data }
    var dataTask: URLSessionDataTask? { return task as? URLSessionDataTask }
    var mutableData: Data = Data()
    var process: (queue: DispatchQueue, handler: (Int64, Int64) -> Void)?
    
    // NSURLSessionDataDelegate
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceiveData data: Data) {
        mutableData.append(data)
        
        if let expectedContentLength = dataTask.response?.expectedContentLength {
            process?.queue.async {
                self.process?.handler(expectedContentLength, Int64(self.mutableData.count))
            }
        }
    }
}

class DownloadTaskHandler: TaskHandler {
    var downloadTask: URLSessionDownloadTask? { return task as? URLSessionDownloadTask }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingToURL location: URL) { }

    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64) { }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) { }
}

class UploadTaskHandler: TaskHandler {
    
}

