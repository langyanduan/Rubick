//
//  Information.swift
//  Rubick
//
//  Created by wufan on 16/8/25.
//
//

import Foundation

public class Information {
    private init() { }
    
    public struct application {
        private init() {}
        
        public static var version: String {
            return NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        }
        
        public static var buildNumber: String {
            return NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String
        }
        
        /// 首次安装或者升级版本后首次启动
        public static var updating: Bool {
            return false
        }
    }
    
    struct device {
        private init() {}
        
        public static var systemVersion: String {
            return UIDevice.currentDevice().systemVersion
        }
        
        public static var systemName: String {
            return UIDevice.currentDevice().systemName
        }
    }
}
