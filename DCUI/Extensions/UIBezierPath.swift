//
//  DCUI
//

import Foundation

public extension UIBezierPath {
    
    public convenience init(points: [Point]) {
        self.init(points: points.makeArray { _,item in
            return item.toCGPoint()
        })
    }
    
    public convenience init(points: [CGPoint]) {
        self.init()
        for (idx,point) in points.enumerated() {
            if idx == 0 {
                move(to: point)
            } else {
                addLine(to: point)
            }
        }
        if points.count > 0 {
            close()
        }
    }
    
}
