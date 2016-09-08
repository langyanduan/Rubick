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
            return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        }
        
        public static var buildNumber: String {
            return Bundle.main.infoDictionary!["CFBundleVersion"] as! String
        }
        
        /// 首次安装或者升级版本后首次启动
        public static var updating: Bool {
            return false
        }
    }
    
    struct device {
        private init() {}
        
        public static var systemVersion: String {
            return UIDevice.current.systemVersion
        }
        
        public static var systemName: String {
            return UIDevice.current.systemName
        }
    }
}
