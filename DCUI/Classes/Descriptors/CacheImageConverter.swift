//
//  DCUI
//

import UIKit

public class CacheImageConverter: CacheConverter {
    
    public enum `Type`: String {
        case PNG
        case JPEG
    }
    public fileprivate(set) var type   : Type = Type.PNG
    public fileprivate(set) var scale  : CGFloat = UIScreen.main.scale
    
    public init() {
        type = .PNG
        scale = UIScreen.main.scale
    }
    
    public init(type: Type, scale: CGFloat = UIScreen.main.scale) {
        self.type = type
        self.scale = scale
    }
    
    open func object(from data: Data?) -> Any? {
        guard let data = data else {return nil}
        return UIImage(data: data, scale: scale)
    }
    
    open func data(from object: Any?) -> Data? {
        if let object = object as? Data {return object}
        guard let object = object as? UIImage else {return nil}
        switch type {
        case .PNG:
            return object.pngData()
        case .JPEG:
            return object.jpegData(compressionQuality: 1)
        }
    }
    
}
