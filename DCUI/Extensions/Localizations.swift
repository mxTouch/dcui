//
//  DCUI
//

import UIKit
import DCFoundation

public extension UIApplication {
    
    func localize() {
        windows.forEach { window in
            window.localize()
        }
    }
    
}

public extension UIWindow {
    
    override func localize() {
        rootViewController?.localize()
    }
    
}

public extension UINavigationController {
    
    override func localize() {
        super.localize()
        viewControllers.forEach { ctrl in
            ctrl.localize()
        }
    }
    
}

public extension UINavigationItem {
    
    fileprivate struct LocalizationKeys {
        static var localizedTitle = "localizedTitle"
    }
    
    @IBInspectable var localizedTitle: String? {
        get {
            return RuntimeGetAssociatedObject(self, key: &LocalizationKeys.localizedTitle)
        }
        set {
            if let value = newValue {
                RuntimeSetAssociatedObject(self, value: value, key: &LocalizationKeys.localizedTitle)
            }
            localize()
        }
    }
    
    func localize() {
        if let title = localizedTitle?.localized {
            self.title = title
        }
    }
    
}

public extension UIViewController {
    
    fileprivate struct LocalizationKeys {
        static var localizedTitle = "localizedTitle"
    }
    
    @IBInspectable var localizedTitle: String? {
        get {
            return RuntimeGetAssociatedObject(self, key: &LocalizationKeys.localizedTitle)
        }
        set {
            if let value = newValue {
                RuntimeSetAssociatedObject(self, value: value, key: &LocalizationKeys.localizedTitle)
            }
            localize()
        }
    }
    
    @objc func localize() {
        if isViewLoaded {
            view.localize()
        }
        if let title = localizedTitle?.localized {
            self.title = title
        }
        let item = UITabBarItem(title: tabBarItem.title, image: tabBarItem.image, selectedImage: tabBarItem.selectedImage)
        item.tag = tabBarItem.tag
        item.localizedTitle = tabBarItem.localizedTitle
        item.localize()
        tabBarItem = item
        
        children.forEach { ctrl in
            ctrl.localize()
        }
        navigationItem.leftBarButtonItem?.localize()
        if let items = navigationItem.leftBarButtonItems {
            for item in items {
                item.localize()
            }
        }
        navigationItem.rightBarButtonItem?.localize()
        if let items = navigationItem.rightBarButtonItems {
            for item in items {
                item.localize()
            }
        }
    }
}

public extension UITabBar {
    
    public override func localize() {
        super.localize()
        layoutIfNeeded()
    }
    
}

public extension UIBarButtonItem {
    
    fileprivate struct LocalizationKeys {
        static var localizedTitle = "localizedTitle"
    }
    
    @IBInspectable var localizedTitle: String? {
        get {
            return RuntimeGetAssociatedObject(self, key: &LocalizationKeys.localizedTitle)
        }
        set {
            if let value = newValue {
                RuntimeSetAssociatedObject(self, value: value, key: &LocalizationKeys.localizedTitle)
            }
            localize()
        }
    }
    
    func localize() {
        if let title = localizedTitle?.localized {
            self.title = title
        }
    }
    
}

public extension UIView {
    @objc public func localize() {
        for view in subviews {
            view.localize()
        }
    }
}

public extension UILabel {
    
    fileprivate struct LocalizationKeys {
        static var localizedText = "localizedText"
    }
    
    @IBInspectable var localizedText: String? {
        get {
            return RuntimeGetAssociatedObject(self, key: &LocalizationKeys.localizedText)
        }
        set {
            if let value = newValue {
                RuntimeSetAssociatedObject(self, value: value, key: &LocalizationKeys.localizedText)
            }
            localize()
        }
    }
    
    override func localize() {
        self.text = localizedText?.localized
    }
    
}

public extension UITextField {
    
    fileprivate struct LocalizationKeys {
        static var localizedText = "localizedText"
        static var localizedPlaceholder = "localizedPlaceholder"
    }
    
    @IBInspectable var localizedText: String? {
        get {
            return RuntimeGetAssociatedObject(self, key: &LocalizationKeys.localizedText)
        }
        set {
            if let value = newValue {
                RuntimeSetAssociatedObject(self, value: value, key: &LocalizationKeys.localizedText)
            }
            localize()
        }
    }
    
    @IBInspectable var localizedPlaceholder: String? {
        get {
            return RuntimeGetAssociatedObject(self, key: &LocalizationKeys.localizedPlaceholder)
        }
        set {
            if let value = newValue {
                RuntimeSetAssociatedObject(self, value: value, key: &LocalizationKeys.localizedPlaceholder)
            }
            localize()
        }
    }
    
    override func localize() {
        if let text = localizedText?.localized {
            self.text = text
        }
        if let placeholder = localizedPlaceholder?.localized {
            self.placeholder = placeholder
        }
    }
    
}

public extension UITabBarItem {
    
    fileprivate struct LocalizationKeys {
        static var localizedTitle = "localizedTitle"
    }
    
    @IBInspectable var localizedTitle: String? {
        get {
            return RuntimeGetAssociatedObject(self, key: &LocalizationKeys.localizedTitle)
        }
        set {
            if let value = newValue {
                RuntimeSetAssociatedObject(self, value: value, key: &LocalizationKeys.localizedTitle)
            }
            localize()
        }
    }
    
    func localize() {
        if let title = localizedTitle?.localized {
            self.title = title
        }
    }
    
}

public extension UIButton {
    
    fileprivate struct LocalizationKeys {
        static var localizedTitle = "localizedTitle"
    }
    
    @IBInspectable var localizedTitle: String? {
        get {
            return RuntimeGetAssociatedObject(self, key: &LocalizationKeys.localizedTitle)
        }
        set {
            if let value = newValue {
                RuntimeSetAssociatedObject(self, value: value, key: &LocalizationKeys.localizedTitle)
            }
            localize()
        }
    }
    
    override func localize() {
        if let title = localizedTitle {
            setTitle(title.localized, for: UIControl.State())
        }
    }
    
}

public extension UITextView {
    
    fileprivate struct LocalizationKeys {
        static var localizedText = "localizedText"
    }
    
    @IBInspectable var localizedText: String? {
        get {
            return RuntimeGetAssociatedObject(self, key: &LocalizationKeys.localizedText)
        }
        set {
            if let value = newValue {
                RuntimeSetAssociatedObject(self, value: value, key: &LocalizationKeys.localizedText)
            }
            localize()
        }
    }
    
    override func localize() {
        text = localizedText?.localized
    }
    
}

public extension UISegmentedControl {
    
    fileprivate struct LocalizationKeys {
        static var localizedTitles = "localizedTitles"
    }
    
    @IBInspectable var localizedTitles: String? {
        get {
            return RuntimeGetAssociatedObject(self, key: &LocalizationKeys.localizedTitles)
        }
        set {
            if let value = newValue {
                RuntimeSetAssociatedObject(self, value: value, key: &LocalizationKeys.localizedTitles)
            }
            localize()
        }
    }
    
    override func localize() {
        if let titles = localizedTitles?.components(separatedBy: ";") {
            for (idx,title) in titles.enumerated() {
                setTitle(title.localized, forSegmentAt: idx)
            }
        }
    }
    
}

public extension UISearchBar {
    
    fileprivate struct LocalizationKeys {
        static var localizedText = "localizedText"
        static var localizedPlaceholder = "localizedPlaceholder"
    }
    
    @IBInspectable var localizedText: String? {
        get {
            return RuntimeGetAssociatedObject(self, key: &LocalizationKeys.localizedText)
        }
        set {
            if let value = newValue {
                RuntimeSetAssociatedObject(self, value: value, key: &LocalizationKeys.localizedText)
            }
            localize()
        }
    }
    
    @IBInspectable var localizedPlaceholder: String? {
        get {
            return RuntimeGetAssociatedObject(self, key: &LocalizationKeys.localizedPlaceholder)
        }
        set {
            if let value = newValue {
                RuntimeSetAssociatedObject(self, value: value, key: &LocalizationKeys.localizedPlaceholder)
            }
            localize()
        }
    }
    
    override func localize() {
        if let text = localizedText?.localized {
            self.text = text
        }
        if let placeholder = localizedPlaceholder?.localized {
            self.placeholder = placeholder
        }
    }
    
}
