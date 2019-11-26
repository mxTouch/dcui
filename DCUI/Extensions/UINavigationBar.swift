//
//  DCUI
//

import Foundation

public extension UINavigationBar {
    
    public func reset() {
        setBackgroundImage(nil, for: .default)
        shadowImage = nil
    }
    
    public func clear() {
        setBackgroundImage(UIImage.draw(size: CGSize(width: width, height: height + 20)) { size,_ in
            UIColor.clear.setFill()
            UIBezierPath(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height)).fill()
        }, for: .default)
        shadowImage = UIImage.draw(size: CGSize(width: width, height: 2)) { size,_ in
            UIColor.clear.setFill()
            UIBezierPath(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height)).fill()
        }
    }
    
}
