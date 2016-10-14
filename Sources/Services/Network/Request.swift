//
//  Request.swift
//  Rubick
//
//  Created by WuFan on 16/9/8.
//
//

import Foundation

public class Request {
    let handler: TaskHandler
    
    public var task: URLSessionTask { return handler.task }
    public var request: URLRequest? { return task.originalRequest }
    public var response: HTTPURLResponse? { return task.response as? HTTPURLResponse }
    
    init(task: URLSessionTask) {
        switch task {
        case is URLSessionUploadTask:
            handler = UploadTaskHandler(task: task)
        case is URLSessionDataTask:
            handler = DataTaskHandler(task: task)
        case is URLSessionDownloadTask:
            handler = DownloadTaskHandler(task: task)
//        case is URLSessionStreamTask: fallthrough
        default:
            assertionFailure()
            handler = TaskHandler(task: task)
        }
    }
    
    public func resume() {
        task.resume()
        NotificationCenter.default.post(name: Notification.Name.Rubick.RequestDidResume, object: self, userInfo: nil)
    }
    public func suspend() {
        task.suspend()
        NotificationCenter.default.post(name: Notification.Name.Rubick.RequestDidSuspend, object: self, userInfo: nil)
    }
    public func cancel() {
        task.cancel()
        NotificationCenter.default.post(name: Notification.Name.Rubick.RequestDidCancel, object: self, userInfo: nil)
    }
}

public class DataRequest: Request {
    var dataHandler: DataTaskHandler { return handler as! DataTaskHandler }
    
    @discardableResult
    public func downloadProcess(queue: DispatchQueue = .main, process: @escaping (Int64, Int64) -> Void) -> Self {
        dataHandler.process = (queue, process)
        return self
    }
}

public class DownloadRequest: Request {
    var downloadHandler: DownloadTaskHandler { return handler as! DownloadTaskHandler }
    
}

public class UploadRequest: Request {
    var uploadHandler: UploadTaskHandler { return handler as! UploadTaskHandler }
}

//public class StreamRequest: Request {}

