//
//  DCUI
//

import UIKit
import DCFoundation

public enum GradientType: Int {
    case linear = 0
    case radial
}

open class Gradient {
    
    open var type         : GradientType
    open var colors       = [UIColor]()
    open var locations    = [CGFloat]()
    open var startPoint   = CGPoint.zero
    open var endPoint     = CGPoint.zero
    open var startRadius  : CGFloat = 0
    open var endRadius    : CGFloat = 0
    open var options      = CGGradientDrawingOptions.drawsBeforeStartLocation
    open var smooth       = false
    fileprivate let smoothStep  : CGFloat = 10
    
    public init(colors: [UIColor], locations: [CGFloat]? = nil, type: GradientType) {
        self.type = type
        self.colors = colors
        if let locations = locations {
            self.locations = locations
        } else {
            for i in 0...colors.count - 1 {
                self.locations << CGFloat(i*1.0/CGFloat(colors.count - 1))
            }
        }
    }
    
    open func draw(context aContext: CGContext? = nil) {
        guard self.colors.count == self.locations.count else {
            print("Gradient: colors and locations need to have equals count")
            return
        }
        guard self.colors.count > 1 else {
            print("Gradient: minimum colors count is 2")
            return
        }
        var context: CGContext! = aContext
        if context == nil {
            context = UIGraphicsGetCurrentContext()
        }
        if self.colors.count == 0 {
            return
        }
        var colors = [CGColor]()
//        var location = [CGFloat]()
        if smooth {
//            for color
        } else {
            colors = self.colors.makeArray { _,item in
                return item.cgColor
            }
        }
        let colorspace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorspace, colors: colors as CFArray, locations: locations)
        switch (type) {
        case .linear:
            context.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: options)
        case .radial:
            context.drawRadialGradient(gradient!, startCenter: startPoint, startRadius: startRadius, endCenter: endPoint, endRadius: endRadius, options: options)
        }
    }
    
}
