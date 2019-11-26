//
//  DCUI
//

import UIKit

public extension UINavigationController {
    
    fileprivate struct NavigationKeys {
        static var navigation = "navigation"
    }
    
    @IBOutlet var navigation: Navigation? {
        get {
            if let value: Navigation = RuntimeGetAssociatedObject(self, key: &NavigationKeys.navigation) {return value}
            return nil
        }
        set {
            newValue?.navigationController = self
            RuntimeSetAssociatedObject(self, value: newValue, key: &NavigationKeys.navigation)
        }
    }
    
}

open class Navigation: NSObject, UINavigationControllerDelegate {
    
    public weak var delegate: UINavigationControllerDelegate?
    weak var navigationController: UINavigationController! {
        didSet {
            delegate = navigationController?.delegate
            navigationController?.delegate = self
        }
    }
    
    // MARK: - UINavigationControllerDelegate
    
    fileprivate func handleShow(_ viewController: UIViewController, animated: Bool) {
        adjustViewController(viewController)
    }

    fileprivate func adjustViewController(_ ctrl: UIViewController) {
        if let barHidden = ctrl.navigationProperties?.barHidden ?? navigationController.navigationProperties?.barHidden {
            navigationController.setNavigationBarHidden(barHidden, animated: true)
        }
        if (ctrl.navigationProperties?.barCleared ?? navigationController.navigationProperties?.barCleared) == true {
            navigationController.navigationBar.clear()
        } else {
            navigationController.navigationBar.reset()
        }
        if let color = ctrl.navigationProperties?.barTintColor ?? navigationController.navigationProperties?.barTintColor {
            navigationController.navigationBar.barTintColor = color
        } else {
            navigationController.navigationBar.barTintColor = UINavigationBar.appearance().tintColor
        }
        let text = ctrl.navigationProperties?.backTitle ?? navigationController.navigationProperties?.backTitle
        let image = (ctrl.navigationProperties?.backImage ?? navigationController.navigationProperties?.backImage)?.withRenderingMode(.alwaysOriginal)
        let font = ctrl.navigationProperties?.backFont ?? navigationController.navigationProperties?.backFont
        if ctrl.navigationItem.leftBarButtonItem == nil && ctrl.navigationItem.leftBarButtonItems == nil && navigationController.viewControllers.count > 1 {
            if text != nil || image != nil {
                ctrl.navigationItem.leftBarButtonItem = UIBarButtonItem(text: text, font: font, image: image) { [weak self]  _ in
                    self?.navigationController.popViewController(animated: true)
                }
            }
        }
    }

    // MARK: - UINavigationControllerDelegate

    open func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        handleShow(viewController, animated: animated)
        delegate?.navigationController?(navigationController, willShow: viewController, animated: animated)
    }
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        delegate?.navigationController?(navigationController, didShow: viewController, animated: animated)
    }

    open func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
        ) -> UIViewControllerAnimatedTransitioning? {
        if let animation = navigationController.viewControllers.last?.transitioningAnimation {
            if animation == "default" {
                return nil
            } else {
                return TransitionAnimation.animationForKey(animation)
            }
        } else {
            return navigationController.transitioningController.navigationAnimation(operation)
        }
    }
    
}

open class NavigationProperties: NSObject {
    
    @IBInspectable var barTintColor: UIColor?

    @IBInspectable var backTitle: String?
    
    @IBInspectable var backFont: UIFont?
    
    @IBInspectable var backImage: UIImage?

    @IBInspectable var barHidden: Bool = false

    @IBInspectable var barCleared: Bool = false
    
    public override init() {
        super.init()
    }
    
}

public extension UIViewController {
    
    fileprivate struct NavigationKeys {
        static var navigationProperties = "navigationProperties"
    }
    
    @IBOutlet var navigationProperties: NavigationProperties? {
        get {
            if let value: NavigationProperties = RuntimeGetAssociatedObject(self, key: &NavigationKeys.navigationProperties) {return value}
            return nil
        }
        set {
            RuntimeSetAssociatedObject(self, value: newValue, key: &NavigationKeys.navigationProperties)
        }
    }
    
}
