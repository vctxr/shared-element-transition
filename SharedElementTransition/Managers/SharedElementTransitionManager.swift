//
//  SharedElementTransitionManager.swift
//  SharedElementTransition
//
//  Created by Victor Samuel Cuaca on 02/11/20.
//

import UIKit

enum TransitionType {
    case present
    case dismiss
    
    var blurAlpha: CGFloat { return self == .present ? 1 : 0 }
    var backdropAlpha: CGFloat { return self == .present ? 0.5 : 0 }
    var closeAlpha: CGFloat { return self == .present ? 1 : 0 }
    var cornerRadius: CGFloat { return self == .present ? 10 : 0 }
    var appCardState: AppCardState { return self == .present ? .card : .full }
    var next: TransitionType { return self == .present ? .dismiss : .present }
}

class SharedElementTransitionManager: NSObject {
    
    let TRANSITION_DURATION: TimeInterval = 0.8
    let SHRINK_DURATION: TimeInterval = 0.05
    
    var transition: TransitionType = .present
    
    
    // MARK: - Supporting Views for Shared Element Transition
    lazy var blurEffectView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        return blurView
    }()
    
    lazy var backdropView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    
    // MARK: - Helper Functions
    private func addBackgroundViews(to containerView: UIView) {
        blurEffectView.frame = containerView.bounds
        blurEffectView.alpha = transition.next.blurAlpha
        
        backdropView.frame = containerView.bounds
        backdropView.alpha = transition.next.backdropAlpha
        
        containerView.addSubview(blurEffectView)
        containerView.addSubview(backdropView)
    }
    
    /// Creates a copy of an AppCardView by value, not by reference.
    private func createAppCardViewCopy(appCardView: AppCardView, withModel appCard: AppCard) -> AppCardView {
        let appCard = appCardView.appCard!
        let cardViewCopy = AppCardView(appCard: appCard, appCardState: transition.appCardState)
        return cardViewCopy
    }
}


// MARK: - Transition Animations
extension SharedElementTransitionManager {
    
    private func createShrinkAnimator(for appCardView: AppCardView) -> UIViewPropertyAnimator {
        return UIViewPropertyAnimator(duration: SHRINK_DURATION, curve: .easeOut) {
            appCardView.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }
    }
    
    private func createExpandContractAnimator(for appCardView: AppCardView, in containerView: UIView, yOrigin: CGFloat) -> UIViewPropertyAnimator {
        let springTiming = UISpringTimingParameters(dampingRatio: 0.7, initialVelocity: CGVector(dx: 0, dy: 5))
        let animator = UIViewPropertyAnimator(duration: TRANSITION_DURATION - SHRINK_DURATION, timingParameters: springTiming)
        
        animator.addAnimations {
            appCardView.transform = .identity
            appCardView.frame.origin.y = yOrigin
            appCardView.containerView.layer.cornerRadius = self.transition.next.cornerRadius
            
            appCardView.updateLayout(for: self.transition.next.appCardState)
            
            self.blurEffectView.alpha = self.transition.blurAlpha
            self.backdropView.alpha = self.transition.backdropAlpha
            
            containerView.layoutIfNeeded()
        }
        
        return animator
    }
    
    private func startTransition(appCardView: AppCardView, containerView: UIView, yOriginToMoveTo: CGFloat, completion: @escaping () -> Void) {
        let shrinkAnimator = createShrinkAnimator(for: appCardView)
        let expandContractAnimator = createExpandContractAnimator(for: appCardView, in: containerView, yOrigin: yOriginToMoveTo)
        
        expandContractAnimator.addCompletion { _ in
            completion()
        }
        
        if transition == .present {
            shrinkAnimator.addCompletion { _ in
                appCardView.layoutIfNeeded()
                expandContractAnimator.startAnimation()
            }
            
            shrinkAnimator.startAnimation()
        } else {
            appCardView.layoutIfNeeded()
            expandContractAnimator.startAnimation()
        }
    }
}

extension SharedElementTransitionManager: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TRANSITION_DURATION
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        containerView.subviews.forEach({ $0.removeFromSuperview() })

        addBackgroundViews(to: containerView)
        
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to)
         
        // For some reason when embedded inside a tab bar controller, the .from vc of the transition is recognized as the tab bar controller, not the Today vc. So need to cast .from vc into a tab bar controller then cast it again to Today vc.
        guard let todayVC = (transition == .present) ? (fromVC as? UITabBarController)?.selectedViewController as? TodayVC
                                                     : (toVC as? UITabBarController)?.selectedViewController as? TodayVC,
              let appCardView = todayVC.getSelectedAppCardView(),
              let appCard = appCardView.appCard
        else { return }
             
        let appCardViewCopy = createAppCardViewCopy(appCardView: appCardView, withModel: appCard)
        let absoluteAppCardViewFrame = appCardView.convert(appCardView.frame, to: nil)
        appCardViewCopy.frame = absoluteAppCardViewFrame
        
        containerView.addSubview(appCardViewCopy)
        appCardView.isHidden = true
        
        if transition == .present {
            let detailView = toVC as! DetailVC
            containerView.addSubview(detailView.view)
            detailView.view.isHidden = true
            
            startTransition(appCardView: appCardViewCopy, containerView: containerView, yOriginToMoveTo: 0) {
                detailView.view.isHidden = false
                appCardViewCopy.removeFromSuperview()
                appCardView.isHidden = false
                transitionContext.completeTransition(true)
            }
        } else {
            let detailVC = fromVC as! DetailVC
            let tabBarController = toVC as! UITabBarController
            guard let tabBar = tabBarController.tabBar.copyView() as? UITabBar,
                  let originalTabBarFrame = todayVC.originalTabBarFrame else { return }
            
            UIView.animateTabBarFrames(tabBar: tabBar, newFrame: originalTabBarFrame)

            containerView.addSubview(tabBar)
            containerView.layoutIfNeeded()
            
            appCardViewCopy.frame = CGRect(x: 0, y: 0, width: detailVC.detailView.appCardView.frame.width, height: detailVC.detailView.appCardView.frame.height)

            startTransition(appCardView: appCardViewCopy, containerView: containerView, yOriginToMoveTo: absoluteAppCardViewFrame.origin.y) {
                appCardViewCopy.removeFromSuperview()
                appCardView.isHidden = false
                transitionContext.completeTransition(true)
            }
        }
    }
}

extension SharedElementTransitionManager: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition = .present
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition = .dismiss
        return self
    }
}
