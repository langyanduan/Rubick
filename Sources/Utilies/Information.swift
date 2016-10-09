//
//  Information.swift
//  Rubick
//
//  Created by wufan on 16/8/25.
//
//

import Foundation

private let KeychainDeviceUUID = "DeviceUUID"

public class Information {
    private init() { }
}

extension Information {
    public struct Application {
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
}

extension Information {
    public struct System {
        public static var version: String {
            return UIDevice.current.systemVersion
        }
        
        public static var name: String {
            return UIDevice.current.systemName
        }
    }
}

extension Information {
    public struct Device {
        private init() {}
        
        public static let uuid: String = {
            if let uuid = Keychain.shared[KeychainDeviceUUID] {
                return uuid
            }
            let uuid = NSUUID().uuidString
            Keychain.shared[KeychainDeviceUUID] = uuid
            return uuid
        }()
        
        // device
        // see: https://github.com/Ekhoo/Device and https://github.com/InderKumarRathore/DeviceGuru
        
        public static let currentSize: Size = getSize()
        public static let currentVersion: Version = getVersion()
        public static let currentType: Type = getType()
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        private static let machine: String = getMachine()
        
        private static func getMachine() -> String {
            var name: [Int32] = [CTL_HW, HW_MACHINE]
            var size: Int = 2
            sysctl(&name, 2, nil, &size, &name, 0)
            var hw_machine = [CChar](repeating: 0, count: Int(size))
            sysctl(&name, 2, &hw_machine, &size, &name, 0)
            return String(cString: hw_machine)
            
    //        var systemInfo = utsname()
    //        uname(&systemInfo)
    //        return NSString(bytes: &systemInfo.machine, length: Int(_SYS_NAMELEN), encoding: String.Encoding.ascii.rawValue)! as String
        }
        
        private static func getSize() -> Size {
            let w: Double = Double(UIScreen.main.bounds.width)
            let h: Double = Double(UIScreen.main.bounds.height)
            let screenHeight: Double = max(w, h)
            
            switch screenHeight {
            case 480:
                return Size.screen3_5Inch
            case 568:
                return Size.screen4Inch
            case 667:
                return UIScreen.main.scale == 3.0 ? Size.screen5_5Inch : Size.screen4_7Inch
            case 736:
                return Size.screen5_5Inch
            case 1024:
                switch currentVersion {
                case .iPadMini,.iPadMini2,.iPadMini3,.iPadMini4:
                    return Size.screen7_9Inch
                default:
                    return Size.screen9_7Inch
                }
            case 1366:
                return Size.screen12_9Inch
            default:
                return Size.unknownSize
            }
        }
        
        private static func getVersion() -> Version {
            switch machine {
            /*** iPhone ***/
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":      return Version.iPhone4
            case "iPhone4,1", "iPhone4,2", "iPhone4,3":      return Version.iPhone4S
            case "iPhone5,1", "iPhone5,2":                   return Version.iPhone5
            case "iPhone5,3", "iPhone5,4":                   return Version.iPhone5C
            case "iPhone6,1", "iPhone6,2":                   return Version.iPhone5S
            case "iPhone7,2":                                return Version.iPhone6
            case "iPhone7,1":                                return Version.iPhone6Plus
            case "iPhone8,1":                                return Version.iPhone6S
            case "iPhone8,2":                                return Version.iPhone6SPlus
            case "iPhone8,4":                                return Version.iPhoneSE
            case "iPhone9,1", "iPhone9,3":                   return Version.iPhone7
            case "iPhone9,2", "iPhone9,4":                   return Version.iPhone7Plus
            
            /*** iPad ***/
            case "iPad1,1", "iPad1,2":                       return Version.iPad1
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return Version.iPad2
            case "iPad3,1", "iPad3,2", "iPad3,3":            return Version.iPad3
            case "iPad3,4", "iPad3,5", "iPad3,6":            return Version.iPad4
            case "iPad4,1", "iPad4,2", "iPad4,3":            return Version.iPadAir
            case "iPad5,3", "iPad5,4":                       return Version.iPadAir2
            case "iPad2,5", "iPad2,6", "iPad2,7":            return Version.iPadMini
            case "iPad4,4", "iPad4,5", "iPad4,6":            return Version.iPadMini2
            case "iPad4,7", "iPad4,8", "iPad4,9":            return Version.iPadMini3
            case "iPad5,1", "iPad5,2":                       return Version.iPadMini4
            case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8": return Version.iPadPro
            
            /*** iPod ***/
            case "iPod1,1":                                  return Version.iPodTouch1Gen
            case "iPod2,1":                                  return Version.iPodTouch2Gen
            case "iPod3,1":                                  return Version.iPodTouch3Gen
            case "iPod4,1":                                  return Version.iPodTouch4Gen
            case "iPod5,1":                                  return Version.iPodTouch5Gen
            case "iPod7,1":                                  return Version.iPodTouch6Gen
            
            /*** Simulator ***/
            case "i386", "x86_64":                           return Version.simulator
            
            default:                                         return Version.unknown
            }
        }
        
        private static func getType() -> Type {
            switch machine {
            case "iPhone3,1", "iPhone3,2", "iPhone3,3",
                 "iPhone4,1", "iPhone4,2", "iPhone4,3",
                 "iPhone5,1", "iPhone5,2",
                 "iPhone5,3", "iPhone5,4",
                 "iPhone6,1", "iPhone6,2",
                 "iPhone7,2",
                 "iPhone7,1",
                 "iPhone8,1",
                 "iPhone8,2",
                 "iPhone8,4",
                 "iPhone9,1", "iPhone9,3",
                 "iPhone9,2", "iPhone9,4":                   return Type.iPhone
                
            case "iPad1,1", "iPad1,2",
                 "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4",
                 "iPad3,1", "iPad3,2", "iPad3,3",
                 "iPad3,4", "iPad3,5", "iPad3,6",
                 "iPad4,1", "iPad4,2", "iPad4,3",
                 "iPad5,3", "iPad5,4",
                 "iPad2,5", "iPad2,6", "iPad2,7",
                 "iPad4,4", "iPad4,5", "iPad4,6",
                 "iPad4,7", "iPad4,8", "iPad4,9",
                 "iPad5,1", "iPad5,2",
                 "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8": return Type.iPad
                
            case "iPod1,1",
                 "iPod2,1",
                 "iPod3,1",
                 "iPod4,1",
                 "iPod5,1",
                 "iPod7,1":                                  return Type.iPod
                
            case "i386", "x86_64":                           return Type.simulator
            default:                                         return Type.unknown
            }
        }
    }
}

extension Information.Device {
    public enum Version: String {
        /*** iPhone ***/
        case iPhone4
        case iPhone4S
        case iPhone5
        case iPhone5C
        case iPhone5S
        case iPhone6
        case iPhone6Plus
        case iPhone6S
        case iPhone6SPlus
        case iPhoneSE
        case iPhone7
        case iPhone7Plus
        
        /*** iPad ***/
        case iPad1
        case iPad2
        case iPadMini
        case iPad3
        case iPad4
        case iPadAir
        case iPadMini2
        case iPadAir2
        case iPadMini3
        case iPadMini4
        case iPadPro
        
        /*** iPod ***/
        case iPodTouch1Gen
        case iPodTouch2Gen
        case iPodTouch3Gen
        case iPodTouch4Gen
        case iPodTouch5Gen
        case iPodTouch6Gen
        
        /*** Simulator ***/
        case simulator
        
        /*** Unknown ***/
        case unknown
    }
    
    public enum Size: Int, Comparable {
        case unknownSize = 0
        case screen3_5Inch
        case screen4Inch
        case screen4_7Inch
        case screen5_5Inch
        case screen7_9Inch
        case screen9_7Inch
        case screen12_9Inch
    }
    
    public enum `Type`: String {
        case iPhone
        case iPad
        case iPod
        case simulator
        case unknown
    }
}

public func <(lhs: Information.Device.Size, rhs: Information.Device.Size) -> Bool {
    return lhs.rawValue < rhs.rawValue
}
