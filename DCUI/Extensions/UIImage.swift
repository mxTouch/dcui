//
//  DCUI
//

import UIKit
import Accelerate
import DCFoundation

public extension UIImage {
    
    public static func image(_ size: CGSize, color: UIColor?) -> UIImage? {
        guard size != CGSize.zero else {return nil}
        guard let color = color else {return nil}
        return UIImage.draw(size: size) { size,_ in
            color.setFill()
            UIBezierPath(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height)).fill()
        }
    }
    
    public func blured(level: CGFloat, tintColor: UIColor? = nil, saturationDeltaFactor: CGFloat = 0.85) -> UIImage? {
        return DCUIMakeImageBlured(self, level, tintColor, saturationDeltaFactor)
    }
    
    public func imageMaskedTo(image: UIImage) -> UIImage? {
        let maskReference = image.cgImage
        
        let imageMask = CGImage(
            maskWidth: (maskReference?.width)!,
            height: (maskReference?.height)!,
            bitsPerComponent: (maskReference?.bitsPerComponent)!,
            bitsPerPixel: (maskReference?.bitsPerPixel)!,
            bytesPerRow: (maskReference?.bytesPerRow)!,
            provider: (maskReference?.dataProvider!)!,
            decode: nil, // Decode is null
            shouldInterpolate: true // Should interpolate
        )
        if let result = cgImage?.masking(imageMask!) {
            return UIImage(cgImage: result)
        }
        return nil
    }
    
    func frameToFitIn(_ size: CGSize, contentMode: ContentMode = .fill, alignment: Alignment = .center) -> CGRect {
        return UIImage.frameToFitIn(self.size, size: size, contentMode: contentMode, alignment: alignment)
    }
    
    static func frameToFitIn(_ originalSize: CGSize, size: CGSize, contentMode: ContentMode = .fill, alignment: Alignment = .center) -> CGRect {
        guard size.width > 0 && size.height > 0 else {return CGRect.zero}
        guard originalSize.width > 0 && originalSize.height > 0 else {return CGRect.zero}
        var newSize = CGSize.zero
        
        switch contentMode {
        case .fill:
            newSize = size
        case .aspectFill:
            if size.width/originalSize.width > size.height/originalSize.height {
                newSize = CGSize(width: size.width, height: originalSize.height*size.width/originalSize.width)
            } else {
                newSize = CGSize(width: originalSize.width*size.height/originalSize.height, height: size.height)
            }
        case .aspectFit:
            if size.width/originalSize.width < size.height/originalSize.height {
                newSize = CGSize(width: size.width, height: originalSize.height*size.width/originalSize.width)
            } else {
                newSize = CGSize(width: originalSize.width*size.height/originalSize.height, height: size.height)
            }
        }
        switch alignment {
        case .top:
            return CGRect(x: (size.width - newSize.width)/2, y: 0, width: newSize.width, height: newSize.height)
        case .topLeft:
            return CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        case .topRight:
            return CGRect(x: size.width - newSize.width, y: 0, width: newSize.width, height: newSize.height)
        case .bottom:
            return CGRect(x: (size.width - newSize.width)/2, y: size.height - newSize.height, width: newSize.width, height: newSize.height)
        case .bottomLeft:
            return CGRect(x: 0, y: size.height - newSize.height, width: newSize.width, height: newSize.height)
        case .bottomRight:
            return CGRect(x: size.width - newSize.width, y: size.height - newSize.height, width: newSize.width, height: newSize.height)
        case .left:
            return CGRect(x: 0, y: (size.height - newSize.height)/2, width: newSize.width, height: newSize.height)
        case .right:
            return CGRect(x: size.width - newSize.width, y: (size.height - newSize.height)/2, width: newSize.width, height: newSize.height)
        case .center:
            return CGRect(x: (size.width - newSize.width)/2, y: (size.height - newSize.height)/2, width: newSize.width, height: newSize.height)
        }
    }
    
    public func imageScaledToSize(_ size: CGSize, contentMode: ContentMode = .fill, alignment: Alignment = .center, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        let frame = frameToFitIn(size, contentMode: contentMode, alignment: alignment)
        guard CGRect.zero != frame else {return nil}
        return UIImage.draw(size: size) { _,_  in
            self.draw(in: frame)
        }
    }
    
    public func imageScaledToSize(percentage: CGSize, contentMode: ContentMode = .fill, alignment: Alignment = .center, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        let newSize = CGSize(width: size.width*percentage.width, height: size.height*percentage.height)
        let frame = frameToFitIn(newSize, contentMode: contentMode, alignment: alignment)
        guard CGRect.zero != frame else {return nil}
        return UIImage.draw(size: size) { _,_  in
            self.draw(in: frame)
        }
    }
    
    public func mirrorHorizonally() -> UIImage {
        return UIImage.draw(size: size) { size,context in
            context.translateBy(x: size.width, y: 0)
            context.scaleBy(x: -1, y: 1)
            self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
    }
    
    public func mirrorVertically() -> UIImage {
        return UIImage.draw(size: size) { size,context in
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1, y: -1)
            self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
    }
    
    fileprivate struct ImageKeys {
        static var imageColors = "imageColors"
    }
    
    public func imageScaledToMaxSize(_ maxSize: CGSize) -> UIImage? {
        return imageScaledToSize(frameToFitIn(maxSize, contentMode: .aspectFill).size)
    }
    
    public func averageColor(_ frame: CGRect? = nil) -> UIColor? {
        var image = self
        if let frame = frame {
            image = image.imageBy(clipping: frame)!
        }
        let rgba = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let context = CGContext(data: rgba, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        context.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: 1, height: 1))
        if rgba[3] > 0 {
            let alpha: CGFloat = CGFloat(rgba[3]) / 255.0
            let multiplier: CGFloat = alpha / 255.0
            return UIColor(red: CGFloat(rgba[0]) * multiplier, green: CGFloat(rgba[1]) * multiplier, blue: CGFloat(rgba[2]) * multiplier, alpha: alpha)
        } else {
            return UIColor(red: CGFloat(rgba[0]) / 255.0, green: CGFloat(rgba[1]) / 255.0, blue: CGFloat(rgba[2]) / 255.0, alpha: CGFloat(rgba[3]) / 255.0)
        }
    }
    
    public func imageBy(clipping frame: CGRect) -> UIImage? {
        guard frame.size.width > 0 && frame.size.height > 0 else {return nil}
        return UIImage.draw(size: frame.size) { _,context in
            context.translateBy(x: -frame.origin.x, y: -frame.origin.y)
            self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        }
    }
    
    public func save(path: String) {
        try? pngData()?.write(to: URL(fileURLWithPath: path), options: [.atomic])
    }
    
    public func convertToGrayScale() -> UIImage? {
        let imageRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.none.rawValue)
        context?.draw(cgImage!, in: imageRect)
        guard let imageRef = context?.makeImage() else {return nil}
        let newImage = UIImage(cgImage: imageRef)
        return newImage
    }
    
    public static func draw(size: CGSize, scale: CGFloat = UIScreen.main.scale, _ handler: ((CGSize, CGContext) -> Void)) -> UIImage {
        var size = size
        if size.width == 0 {
            size.width = 1
        }
        if size.height == 0 {
            size.height = 1
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        if let context = UIGraphicsGetCurrentContext() {
            handler(size, context)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}

public extension String {
    
    public func toUIImage() -> UIImage? {
        return UIImage(named: self)
    }
    
}

public func UIImageNamed(_ name: String?) -> UIImage? {
    if let name = name {
        return UIImage(named: name)
    }
    return nil
}

public func UIImageNamedResizable(_ name: String, insets: UIEdgeInsets = UIEdgeInsets.zero, mode: UIImage.ResizingMode = .tile) -> UIImage? {
    return UIImageNamed(name)?.resizableImage(withCapInsets: insets, resizingMode: mode)
}

public func UIImageNamedRendering(_ name: String, mode: UIImage.RenderingMode) -> UIImage? {
    return UIImageNamed(name)?.withRenderingMode(mode)
}
