//
//  DCUI
//

import Foundation

public enum DeviceType {
    case unknown
    case iphone5
    case iphone5c
    case iphone5s
    case iphone5se
    case iphone6
    case iphone6s
    case iphone6Plus
    case iphone6sPlus
    case iphone7
    case iphone7Plus
}

public extension UIDevice {
    
    var platform: String {
        var size = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0,  count: Int(size))
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return String(cString: machine)
    }
    
    var type: DeviceType {
        switch platform {
        case "iPhone5,1", "iPhone5,2":  return .iphone5
        case "iPhone5,3", "iPhone5,4":  return .iphone5c
        case "iPhone6,1", "iPhone6,2":  return .iphone5s
        case "iPhone8,4":               return .iphone5se
        case "iPhone7,2":               return .iphone6
        case "iPhone7,1":               return .iphone6Plus
        case "iPhone8,1":               return .iphone6s
        case "iPhone8,2":               return .iphone6sPlus
        case "iPhone9,1", "iPhone9,3":  return .iphone7
        case "iPhone9,2", "iPhone9,4":  return .iphone7Plus
        default:                        return .unknown
        }
    }
    
}
