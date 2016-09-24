//
//  ImageSerializer.swift
//  Rubick
//
//  Created by WuFan on 16/9/20.
//
//

import Foundation

struct ImageDecoder {
    enum Format {
        case jpeg
        case png
        case gif
        case webp
        case unknown
    }
    
    
    static func format(ofData data: Data) -> Format {
        guard data.count > 10 else {
            return .unknown
        }
        /**
         png
           File format: |89 50 4E 47 0D 0A 1A 0A ...|
           References: https://en.wikipedia.org/wiki/Portable_Network_Graphics
         
         gif
           File format: |47 49 46 38 ... 3B|
           References: https://en.wikipedia.org/wiki/GIF
                       http://www.onicos.com/staff/iz/formats/gif.html
         
         jpeg
           File format: |FF D8 FF ... FF D9|
           References: https://en.wikipedia.org/wiki/JPEG_File_Interchange_Format
                       http://dev.exiv2.org/projects/exiv2/wiki/The_Metadata_in_JPEG_files
        */
        
        switch (data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7], data[data.count - 2], data[data.count - 1]) {
        case (0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, _, _):
            return .png
        case (0x47, 0x49, 0x46, 0x38, _, _, _, _, _, 0x3B):
            return .gif
        case (0xFF, 0xD8, 0xFF, _, _, _, _, _, 0xFF, 0xD9):
            return .jpeg
        default:
            return .unknown
        }
    }
    
    static func image(fromData data: Data, scale: CGFloat) -> UIImage? {
        switch format(ofData: data) {
        case .jpeg, .png:
            return UIImage.ext.decode(fromData: data, scale: scale)
        case .gif:  // return first frame
            return nil
        default:
            return nil
        }
    }
}
