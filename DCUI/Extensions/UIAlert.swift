//
//  DCUI
//

import UIKit

public extension UIAlertAction {
    
    public var isChecked: Bool {
        set {setValue(newValue, forKey: "checked")}
        get {return (value(forKey: "checked") as? Bool) ?? false}
    }
    
}

fileprivate func FindWindow() -> UIWindow? {
    var window: UIWindow?
    for item in UIApplication.shared.windows {
        if  !NSStringFromClass(item.classForCoder).contains("UIRemoteKeyboardWindow") &&
            !NSStringFromClass(item.classForCoder).contains("_UIInteractiveHighlightEffectWindow") &&
            !NSStringFromClass(item.classForCoder).contains("UITextEffectsWindow") {
            window = item
        }
    }
    return window
}

public func ShowLocalizedAlert(text: String? = nil, inViewController: UIViewController? = nil) {
    var ctrl = inViewController
    if ctrl == nil {
        ctrl = FindWindow()?.rootViewController
    }
    if let ctrl = ctrl {
        let alert = UIAlertController(title: nil, message: text?.localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "general.button.ok".localized, style: .cancel, handler: { _ in}))
        ctrl.present(alert, animated: true, completion: nil)
    }
    
}

public func ShowLocalizedAlert(title: String? = nil, text: String? = nil, cancel: String? = nil, style: UIAlertController.Style = .alert, actions: [UIAlertAction], inViewController: UIViewController? = nil) {
    var ctrl = inViewController
    if ctrl == nil {
        ctrl = FindWindow()?.rootViewController
    }
    if let ctrl = ctrl {
        let alert = UIAlertController(title: title?.localized, message: text?.localized, preferredStyle: style)
        var hasCancel = false
        for item in actions {
            if item.style == .cancel {
                hasCancel = true
            }
            alert.addAction(item)
        }
        if !hasCancel {
            if let cancel = cancel {
                alert.addAction(UIAlertAction(title: cancel.localized, style: .cancel, handler: { _ in}))
            }
        }
        ctrl.present(alert, animated: true, completion: nil)
    }
    
}

public func ShowLocalizedAlert(error: Error?, inViewController: UIViewController? = nil) {
    if let error = error {
        ShowLocalizedAlert(text: error.localizedDescription, inViewController: inViewController)
    }
}

public extension UIAlertAction {
    
    public convenience init(title: String, _ handler: ((UIAlertAction) -> Void)?) {
        self.init(title: title.localized, style: .default, handler: handler)
    }
}
