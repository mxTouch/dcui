//
//  DCUI
//

import UIKit

public extension UITableView {
    
    public func register(cellClass: AnyClass?, reuseIdentifier: String? = nil) {
        var identifier = (cellClass as? UITableViewCell.Type)!.cellId()
        if let id = reuseIdentifier {
            identifier = id
        }
        if let _ = Bundle.main.path(forResource: identifier, ofType: "nib") {
            register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        } else {
            register(cellClass, forCellReuseIdentifier: identifier)
        }
    }
    
    public func dequeueReusableCell<T:UITableViewCell>(identifier: String = T.cellId(), indexPath: IndexPath? = nil) -> T {
        if let ip = indexPath {
            return self.dequeueReusableCell(withIdentifier: identifier, for: ip) as! T
        } else {
            return self.dequeueReusableCell(withIdentifier: identifier) as! T
        }
    }
    
}
