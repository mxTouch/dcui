//
//  DCUI
//

import UIKit
import DCFoundation

public extension UIView {

    
    fileprivate struct UIViewPrivate {
        static var identifier = "view_identifier"
        static var cache = [String:[UIView]]()
    }
    
    @IBInspectable public var identifier: String? {
        get { return RuntimeGetAssociatedObject(self, key: &UIViewPrivate.identifier) }
        set { RuntimeSetAssociatedObject(self, value: newValue, key: &UIViewPrivate.identifier) }
    }
    
    public func view<T:UIView>(identifier: String, type: T.Type? = nil) -> T? {
        for view in subviews {
            if view.identifier == identifier {
                return view as? T
            } else if let view = view.view(identifier: identifier, type: type) {
                return view
            }
        }
        return nil
    }
    
    public static func view<T:UIView>(identifier: String? = nil, cached: Bool = false) -> T? {
        if cached {
            if let view: T = UIViewCache.shared.dequeueReusableView(NSStringFromClass(self), identifier: identifier) {
                return view
            }
        }
        guard let name = NSStringFromClass(self).components(separatedBy: ".").last else {return nil}
        if let _ = Bundle.main.path(forResource: name, ofType: "nib") {
            if let items = Bundle.main.loadNibNamed(name, owner: nil, options: nil) as? [UIView] {
                for item in items {
                    if let identifier = identifier {
                        if let view = item as? T {
                            if view.identifier == identifier {
                                if cached {
                                    UIViewCache.shared.trackView(view)
                                }
                                return view
                            }
                        }
                    } else if let view = item as? T {
                        if cached {
                            UIViewCache.shared.trackView(view)
                        }
                        return view
                    }
                }
            }
        } else if let view = self.init() as? T {
            if cached {
                UIViewCache.shared.trackView(view)
            }
            return view
        }
        return nil
    }
    
    public var originX: CGFloat {
        set { frame = CGRect(x: newValue, y: originY, width: width, height: height) }
        get { return frame.origin.x }
    }
    
    public var originY: CGFloat {
        set { frame = CGRect(x: originX, y: newValue, width: width, height: height) }
        get { return frame.origin.y }
    }
    
    public var width: CGFloat {
        set { frame = CGRect(x: originX, y: originY, width: newValue, height: height) }
        get { return frame.size.width }
    }
    
    public var height: CGFloat {
        set { frame = CGRect(x: originX, y: originY, width: width, height: newValue) }
        get { return frame.size.height }
    }
    
    public var origin: CGPoint {
        set { frame = CGRect(x: newValue.x, y: newValue.y, width: width, height: height) }
        get { return frame.origin }
    }
    
    public var size: CGSize {
        set { frame = CGRect(x: originX, y: originY, width: newValue.width, height: newValue.height) }
        get { return frame.size }
    }
    
    public func snapshot(frame: CGRect = CGRect.zero) -> UIImage? {
        var frame = frame
        if frame == CGRect.zero {
            frame = CGRect(x: 0, y: 0, width: width, height: height)
        }
        return UIImage.draw(size: frame.size) { _,context in
            context.translateBy(x: -frame.origin.x, y: -frame.origin.y)
            self.drawHierarchy(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height), afterScreenUpdates: true)
        }
    }
    
    public func pulsate(duration: CFTimeInterval) {
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = duration
        pulseAnimation.fromValue = 0
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = Float.greatestFiniteMagnitude
        pulseAnimation.isRemovedOnCompletion = false
        self.layer.add(pulseAnimation, forKey: nil)
    }
    
}

public func << (lhs: UIView?, rhs: UIView?) {
    guard let lhs = lhs else {return}
    if let rhs = rhs {
        lhs.addSubview(rhs)
    }
}

extension UIView {
    
    @IBInspectable open var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable open var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable open var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set { layer.borderColor = newValue?.cgColor }
    }
    
}
