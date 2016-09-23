//
//  UIKit+ImageDownload.swift
//  Rubick
//
//  Created by WuFan on 2016/9/23.
//
//

import Foundation
import UIKit

extension InstanceExtension where Base: UIImageView {
    func setImage(withURLString urlString: String?, placeholer: UIImage? = nil, downloader: ImageDownloader = .shared) {
        guard let urlString = urlString else {
            LogW("urlString is nil")
            return
        }
        guard let url = URL(string: urlString) else {
            LogW("convert urlString to url fail!")
            return
        }
        setImage(withURL: url, placeholer: placeholer, downloader: downloader)
    }
    
    func setImage(withURL url: URL, placeholer: UIImage? = nil, downloader: ImageDownloader = .shared) {
        if let image = downloader.memoryImage(withURL: url) {
            base.image = image
            return
        }
        
        base.image = placeholer
    }
}
