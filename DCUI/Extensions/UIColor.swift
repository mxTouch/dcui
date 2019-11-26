//
//  DCUI
//

import UIKit

public extension UIColor {
    
    convenience init?(hex: String) {
        var cString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if cString.length != 6 {return nil}
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
    }
    
    convenience init(red255 red: CGFloat, green255 green: CGFloat, blue255 blue: CGFloat, alpha: CGFloat) {
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
    
    convenience init(rgb: Int) {
        self.init(hex: String(format:"#%06X", (0xFFFFFF & rgb)))!
    }
    
    public var colorSpaceModel: CGColorSpaceModel {
        return self.cgColor.colorSpace!.model
    }
    
    public var canProvideRGBComponents: Bool {
        return ((self.colorSpaceModel == .rgb)||(self.colorSpaceModel == .monochrome))
    }
    
    public var red: CGFloat {
        let c = self.cgColor.components
        return c![0]
    }
    
    public var green: CGFloat {
        let c = self.cgColor.components
        if self.colorSpaceModel == .monochrome {
            return c![0]
        }
        return c![1]
    }
    
    public var blue: CGFloat {
        let c = self.cgColor.components
        if self.colorSpaceModel == .monochrome {
            return c![0]
        }
        return c![2]
    }
    
    public var alpha: CGFloat {
        let c = self.cgColor.components
        if self.colorSpaceModel == .monochrome {
            return c![0]
        }
        return c![self.cgColor.numberOfComponents - 1]
    }
    
    public var hue: CGFloat {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return hue
    }
    
    public var saturation: CGFloat {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return saturation
    }
    
    public var brightness: CGFloat {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return brightness
    }
    
    public func toInt() -> Int {
        var rgb = (red*255).toInt();
        rgb = (rgb << 8) + (green*255).toInt();
        rgb = (rgb << 8) + (blue*255).toInt();
        return rgb
    }
    
    public func toHex() -> String? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
    
    func colorByAppliyingColor(_ color: UIColor?, blendMode: CGBlendMode) -> UIColor {
        return UIColor(patternImage: UIImage.draw(size: CGSize(width: 1, height: 1)) { (size,context) in
            let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            self.setFill()
            path.fill()
            context.setBlendMode(blendMode)
            color?.setFill()
            path.fill()
        })
    }
    
    var hasLightContrast: Bool {
        let value = red*255*CGFloat(0.299) + green*255*CGFloat(0.587) + blue*255*CGFloat(0.114)
        return value > 186
    }
    
    var hasDarkContrast: Bool {
        return !hasLightContrast
    }
    
    static func random() -> UIColor {
        return UIColor(red255: CGFloat(arc4random()%UInt32(256)), green255: CGFloat(arc4random()%UInt32(256)), blue255: CGFloat(arc4random()%UInt32(256)), alpha: 1.0)
    }
    
}

public extension String {
    
    func toUIColor() -> UIColor {
        return UIColor(hex: self) ?? UIColor.clear
    }
    
}

public prefix func !(lhs: UIColor?) -> Bool {
    return (lhs == nil)
}
