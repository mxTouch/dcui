//
//  DCUI
//

import UIKit

public extension UIViewController {
    
    fileprivate struct TransitionAnimationKeys {
        static var transitioningController = "transitioningController"
    }
    
    public var transitioningAnimation: String? {
        get {
            return transitioningController.defaultAnimation
        }
        set {
            transitioningController.defaultAnimation = newValue
        }
    }
    
    internal var transitioningController: TransitionController! {
        get {
            if let value: TransitionController = RuntimeGetAssociatedObject(self, key: &TransitionAnimationKeys.transitioningController) {
                return value
            }
            let ctrl = TransitionController()
            ctrl.viewController = self
            self.transitioningController = ctrl
            return ctrl
        }
        set {
            if let value = newValue {
                RuntimeSetAssociatedObject(self, value: value, key: &TransitionAnimationKeys.transitioningController)
            }
        }
    }
    
}

public extension UINavigationController {
    
    func setViewControllers(_ viewControllers: [UIViewController], animation: String?) {
        if let animation = animation {
            transitioningController.currentAnimation = animation
        }
        setViewControllers(viewControllers, animated: true)
    }
    
}

class TransitionController: NSObject, UIViewControllerTransitioningDelegate {

    var viewController: UIViewController! {
        didSet {
            viewController.transitioningDelegate = self
        }
    }
    
    var defaultAnimation: String?
    var currentAnimation: String?
    
    func navigationAnimation(_ operation: UINavigationController.Operation) -> TransitionAnimation? {
        if let animation = TransitionAnimation.animationForKey(currentAnimation) {
            currentAnimation = nil
            animation.navigationOperation = operation
            animation.prepare()
            return animation
        } else if let animation = TransitionAnimation.animationForKey(defaultAnimation) {
            animation.navigationOperation = operation
            animation.prepare()
            return animation
        }
        return nil
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return nil
    }
    
}
