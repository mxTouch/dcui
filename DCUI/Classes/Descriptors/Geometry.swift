//
//  DCUI
//

import DCFoundation

public enum Alignment {
    case top
    case topLeft
    case topRight
    case bottom
    case bottomLeft
    case bottomRight
    case left
    case right
    case center
}

public enum ContentMode {
    case fill
    case aspectFill
    case aspectFit
}

public extension Point {
    
    public init(point: CGPoint) {
        self.init()
        x = Double(point.x)
        y = Double(point.y)
    }
    
    public func toCGPoint(_ scale: CGFloat = 1) -> CGPoint {
        return CGPoint(x: CGFloat(x*scale), y: CGFloat(y*scale))
    }
    
}

public extension Size {
    
    public init(size: CGSize) {
        self.init()
        width = size.width.toDouble()
        height = size.height.toDouble()
    }
    
    public func toCGSize(_ scale: CGFloat = 1) -> CGSize {
        return CGSize(width: width*scale, height: height*scale)
    }
    
}

public extension Rect {
    
    public init(rect: CGRect) {
        self.init()
        origin = Point(Double(rect.origin.x), Double(rect.origin.y))
        size = Size()
    }
    
    public func toCGRect(_ scale: CGFloat = 1) -> CGRect {
        return CGRect(x: CGFloat(origin.x*scale), y: CGFloat(origin.y*scale), width: CGFloat(size.width*scale), height: CGFloat(size.height*scale))
    }
    
}

public func + (lhs: Rect, rhs: Rect) -> Rect {
    return Rect(lhs.origin.x + rhs.origin.x, lhs.origin.y + rhs.origin.y, lhs.size.width + rhs.size.width, lhs.size.height + rhs.size.height)
}

// MARK: - CGPoint +

public func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

public func + (lhs: CGPoint, rhs: (x: CGFloat, y: CGFloat)) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

public func + (lhs: CGPoint, rhs: (x: Int, y: Int)) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

public func + (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    return CGPoint(x: lhs.x + rhs, y: lhs.y + rhs)
}

public func + (lhs: CGPoint, rhs: Point) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

// MARK: - CGPoint -

public func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

public func - (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    return CGPoint(x: lhs.x - rhs, y: lhs.y - rhs)
}

public func - (lhs: CGPoint, rhs: Point) -> CGPoint {
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

// MARK: - CGPoint +=

public func += (lhs: inout CGPoint, rhs: CGPoint) {
    lhs.x += rhs.x
    lhs.y += rhs.y
}

public func += (lhs: inout CGPoint, rhs: (x: CGFloat, y: CGFloat)) {
    lhs.x += rhs.x
    lhs.y += rhs.y
}

// MARK: - CGSize +=

public func += (lhs: inout CGSize, rhs: CGPoint) {
    lhs.width += rhs.x
    lhs.height += rhs.y
}

public func += (lhs: inout CGSize, rhs: CGSize) {
    lhs.width += rhs.width
    lhs.height += rhs.height
}

public func += (lhs: inout CGSize, rhs: (x: CGFloat, y: CGFloat)) {
    lhs.width += rhs.x
    lhs.height += rhs.y
}

public func += (lhs: inout CGSize, rhs: CGFloat) {
    lhs.width += rhs
    lhs.height += rhs
}

public func CGPointDistance(_ point1: CGPoint, point2: CGPoint) -> CGFloat {
    return sqrt((point2.x - point1.x)*(point2.x - point1.x) + (point2.y - point1.y)*(point2.y - point1.y))
}
