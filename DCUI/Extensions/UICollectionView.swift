//
//  DCUI
//

import Foundation

public extension UICollectionView {
    
    public func dequeueReusableCell<T:UICollectionViewCell>(identifier: String, indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }
    
}
