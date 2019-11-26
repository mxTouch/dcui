//
//  DCUI
//

import Foundation

public extension NSObject {
    
    fileprivate struct StyleKeys {
        static var styleName = "styleName"
    }
    
    @IBInspectable var styleName: String? {
        get {
            return RuntimeGetAssociatedObject(self, key: &StyleKeys.styleName)
        }
        set {
            if let value = newValue {
                RuntimeSetAssociatedObject(self, value: value, key: &StyleKeys.styleName)
            }
            applyStyle()
        }
    }
    
    @objc func applyStyle() {
        guard let style = Style.for(object: self) else {return}
        if let className = style.className {
            guard NSStringFromClass(self.classForCoder).components(separatedBy: ".").last == className else {return}
        }
        for (key,value) in style.properties {
            setValue(styleProperty(key: key, value: value), forKey: key)
        }
    }
    
    @objc func styleProperty(key: String, value: AnyObject?) -> AnyObject? {
        return value
    }
    
}

public extension UIView {
    
    override func styleProperty(key: String, value: AnyObject?) -> AnyObject? {
        switch key {
        case "backgroundColor": return (value as? String)?.toUIColor()
        default:
            return super.styleProperty(key: key, value: value)
        }
    }
    
}

public extension UIApplication {
    
    override func applyStyle() {
        windows.forEach { window in
            window.applyStyle()
        }
    }
    
}

public extension UIWindow {
    
    override public func applyStyle() {
        rootViewController?.applyStyle()
    }
    
}

public extension UIViewController {
    
    override func applyStyle() {
        super.applyStyle()
        view.applyStyle()
        children.forEach { ctrl in
            ctrl.applyStyle()
        }
    }
    
}

public extension UIView {
    
    override func applyStyle() {
        super.applyStyle()
        subviews.forEach { view in
            view.applyStyle()
        }
    }
    
}
