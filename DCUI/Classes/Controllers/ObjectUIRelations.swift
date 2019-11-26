//
//  DCUI
//

import UIKit
import DCFoundation

public extension UIViewController {
    
    fileprivate struct RelationsKeys {
        static var relations = "localizedTitle"
    }
    
    @IBOutlet public var relations: ObjectUIRelations? {
        get {
            return RuntimeGetAssociatedObject(self, key: &RelationsKeys.relations)
        }
        set {
            if let value = newValue {
                RuntimeSetAssociatedObject(self, value: value, key: &RelationsKeys.relations)
            }
        }
    }
}

open class ObjectUIRelations: NSObject {
    
    @IBOutlet open var views: [UIView]? {
        didSet {
            if let views = views {
                for view in views {
                    if connectView(view) {
                        relationViews << view
                    }
                }
            }
        }
    }
    open fileprivate(set) var relationViews = [UIView]()
    
    public enum ConnectionType {
        case `in`
        case out
        case inOut
    }
    
    open class ConnectionItem: NSObject {
        weak var object: NSObject?
        var key: String!
        var type = ConnectionType.in
        var identifier: String!
        var inValue:((AnyObject?) -> AnyObject?)!
        var outValue:((AnyObject?) -> AnyObject?)!
        
        public init(object: NSObject, key: String, identifier: String? = nil, type: ConnectionType = .in, inValue:((AnyObject?) -> AnyObject?)? = nil, outValue:((AnyObject?) -> AnyObject?)? = nil) {
            super.init()
            self.object = object
            self.key = key
            self.type = type
            if let identifier = identifier {
                self.identifier = identifier
            } else {
                self.identifier = key
            }
            if let inValue = inValue {
                self.inValue = inValue
            } else {
                self.inValue = { object in
                    return object
                }
            }
            if let outValue = outValue {
                self.outValue = outValue
            } else {
                self.outValue = { object in
                    return object
                }
            }
        }
        
    }
    
    var items = [ConnectionItem]()
    
    deinit {
        clear()
    }
    
    func addItem(_ item: ConnectionItem) {
        guard items.index(of: item) == nil else {
            return
        }
        connectItem(item)
        items << item
    }
    
    func removeItem(_ item: ConnectionItem) {
        disconnectItem(item)
        items -= item
    }
    
    func addView(_ view: UIView) {
        guard relationViews.index(of: view) == nil else {
            return
        }
        _ = connectView(view)
        relationViews << view
    }
    
    func removeView(_ view: UIView) {
        disconnectView(view)
        relationViews -= view
    }
    
    open func refresh() {
        for view in relationViews {
            for item in items {
                updateView(view, item: item)
            }
        }
    }
    
    open func clear() {
        while items.count > 0 {
            removeItem(items.first!)
        }
        while relationViews.count > 0 {
            removeView(relationViews.first!)
        }
    }
    
    // MARK: - Connect
    
    fileprivate var kvoContext: UInt8 = 1
    
    func connectItem(_ item: ConnectionItem) {
        item.object?.addObserver(self, forKeyPath: item.key, options: [.new], context: &kvoContext)
        for view in relationViews {
            updateView(view, item: item)
        }
    }
    
    func disconnectItem(_ item: ConnectionItem) {
        item.object?.removeObserver(self, forKeyPath: item.key)
    }
    
    func connectView(_ view: UIView) -> Bool {
        var connected = false
        if let view = view as? UISwitch {
            view.addTarget(self, action: #selector(ObjectUIRelations.onSwitch(_:)), for: .valueChanged)
            connected = true
        } else if let view = view as? UITextField {
            NotificationAdd(observer: self, selector: #selector(ObjectUIRelations.onTextField(_:)), name: UITextField.textDidChangeNotification.rawValue, object: view)
            connected = true
        } else if let view = view as? UISegmentedControl {
            view.addTarget(self, action: #selector(ObjectUIRelations.onSegmentedControl(_:)), for: .valueChanged)
            connected = true
        }
        if connected {
            for item in items {
                updateView(view, item: item)
            }
        }
        return connected
    }
    
    func disconnectView(_ view: UIView) {
        if let view = view as? UISwitch {
            view.removeTarget(self, action: #selector(ObjectUIRelations.onSwitch(_:)), for: .valueChanged)
        } else if let view = view as? UITextField {
            NotificationRemove(observer: self, name: UITextField.textDidChangeNotification.rawValue, object: view)
        } else if let view = view as? UISegmentedControl {
            view.removeTarget(self, action: #selector(ObjectUIRelations.onSegmentedControl(_:)), for: .valueChanged)
        }
    }
    
    // MARK: - Update

    func updateView(_ view: UIView, item: ConnectionItem) {
        /*
        guard view.identifier == item.identifier else {
            return
        }
        guard item.type == .out || item.type == .inOut else {
            return
        }
        if let view = view as? UISwitch {
            if let value = item.outValue(item.object?.value(forKey: item.key)) as? Bool {
                view.isOn = value
            }
        } else if let view = view as? UITextField {
            view.text = item.outValue(item.object?.value(forKey: item.key)) as? String
        } else if let view = view as? UISegmentedControl {
            if let index = item.outValue(item.object?.value(forKey: item.key)) as? Int {
                view.selectedSegmentIndex = index
            }
        } else if let view = view as? UILabel {
            view.text = item.outValue(item.object?.value(forKey: item.key)) as? String
        }
 */
    }
    
    func updateItem(_ item: ConnectionItem, view: UIView) {
        /*
        guard view.identifier == item.identifier else {
            return
        }
        guard item.type == .in || item.type == .inOut else {
            return
        }
        if let view = view as? UISwitch {
            item.object?.setValue(item.inValue(view.isOn), forKey: item.key)
        } else if let view = view as? UITextField {
            item.object?.setValue(item.inValue(view.text), forKey: item.key)
        } else if let view = view as? UISegmentedControl {
            item.object?.setValue(item.inValue(view.selectedSegmentIndex), forKey: item.key)
        } else if let view = view as? UILabel {
            item.object?.setValue(item.inValue(view.text), forKey: item.key)
        }
 */
    }
    
    // MARK: - Observation
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let object = object as? NSObject else {
            return
        }
        for item in items {
            if item.object == object {
                for view in relationViews {
                    updateView(view, item: item)
                }
            }
        }
    }
 
    @objc open func onSwitch(_ sender: UISwitch) {
        for item in items {
            updateItem(item, view: sender)
        }
    }
    
    @objc open func onTextField(_ ntf: Notification) {
        if let view = ntf.object as? UIView {
            for item in items {
                updateItem(item, view: view)
            }
        }
    }
    
    @objc open func onSegmentedControl(_ sender: UISegmentedControl) {
        for item in items {
            updateItem(item, view: sender)
        }
    }
    
}

func == (left: ObjectUIRelations.ConnectionItem, right: ObjectUIRelations.ConnectionItem) -> Bool {
    return left.object == right.object && left.identifier == right.identifier && left.type == right.type
}

public func << (left: ObjectUIRelations?, view: UIView?) {
    if let view = view {
        left?.addView(view)
    }
}

// MARK: - In/Out

//public func <<-->> (left: ObjectUIRelations?, right: (object: NSObject, key: String)) {
//    left?.addItem(ObjectUIRelations.ConnectionItem(object: right.object, key: right.key, identifier: right.key, type: .inOut))
//}
//
//public func <<-->> (left: ObjectUIRelations?, right: (object: NSObject, key: String, identifier: String)) {
//    left?.addItem(ObjectUIRelations.ConnectionItem(object: right.object, key: right.key, identifier: right.identifier, type: .inOut))
//}
//
//public func <<-->> (left: ObjectUIRelations?, right: ObjectUIRelations.ConnectionItem) {
//    right.type = .inOut
//    left?.addItem(right)
//}
//
//// MARK: - Out
//
//public func -->> (left: ObjectUIRelations?, right: (object: NSObject, key: String)) {
//    left?.addItem(ObjectUIRelations.ConnectionItem(object: right.object, key: right.key, identifier: right.key, type: .out))
//}
//
//public func -->> (left: ObjectUIRelations?, right: ObjectUIRelations.ConnectionItem) {
//    right.type = .out
//    left?.addItem(right)
//}
//
//// MARK: - In
//
//public func <<-- (left: ObjectUIRelations?, right: (object: NSObject, identifier: String)) {
//    left?.addItem(ObjectUIRelations.ConnectionItem(object: right.object, key: right.identifier, identifier: right.identifier, type: .in))
//}
//
//public func <<-- (left: ObjectUIRelations?, right: ObjectUIRelations.ConnectionItem) {
//    right.type = .in
//    left?.addItem(right)
//}
