//
//  DCUI
//

import UIKit

open class TransitionFade: TransitionAnimation {
    
    override open var name: String {
        return "fade"
    }
    
    override open func prepare() {
        self.animationDuration = 0.6
    }
    
    override open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        transitionContext.containerView.insertSubview(transitionContext.toViewController.view, belowSubview: transitionContext.fromViewController.view)
        transitionContext.toViewController.view.alpha = 0
        transitionContext.fromViewController.view.alpha = 1
        transitionContext.containerView.backgroundColor = transitionContext.toViewController.view.backgroundColor
        
        UIView.animate(withDuration: self.animationDuration/2, animations: {
            transitionContext.fromViewController.view.alpha = 0
            transitionContext.toViewController.view.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: self.animationDuration/2, animations: {
                transitionContext.toViewController.view.alpha = 1
            }, completion: { _ in
                transitionContext.completeTransition(true)
            }) 
        }) 
        
    }
    
}
