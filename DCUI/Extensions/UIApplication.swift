//
//  DCUI
//

import UIKit

public extension UIApplication {
    
    public func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            open(url)
        }
    }
    
}
