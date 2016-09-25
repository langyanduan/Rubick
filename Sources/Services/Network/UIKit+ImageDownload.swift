//
//  UIKit+ImageDownload.swift
//  Rubick
//
//  Created by WuFan on 2016/9/23.
//
//

import Foundation
import UIKit

private var associatedKey: Void = ()

extension InstanceExtension where Base: UIImageView {
    
    private func setDownloadTask(_ task: ImageDownloader.Task) {
        objc_setAssociatedObject(base, &associatedKey, task, .OBJC_ASSOCIATION_RETAIN)
    }
    
    public var downloadTask: ImageDownloader.Task? {
        get { return objc_getAssociatedObject(base, &associatedKey) as? ImageDownloader.Task }
    }
    
    public func setImage(with url: URLConvertible, placeholer: UIImage? = nil, downloader: ImageDownloader = .shared) {
        guard let url = try? url.asURL() else {
            LogW("convert  to url fail!")
            return
        }
        setImage(withURL: url, placeholer: placeholer, downloader: downloader)
    }
    
    func setImage(withURL url: URL, placeholer: UIImage? = nil, downloader: ImageDownloader = .shared) {
        downloadTask?.cancel(alsoDownload: false)
        
        asyncOnMainQueue {
            self.base.image = placeholer
        }
        
        let task = downloader.fetchImage(withURL: url) { (image, canceled) in
            if canceled || image == nil {
                return
            }
            
            asyncOnMainQueue {
                self.base.image = image
            }
        }
        
        setDownloadTask(task)
    }
}
