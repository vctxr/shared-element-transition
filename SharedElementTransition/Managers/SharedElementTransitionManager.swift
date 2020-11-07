//
//  SharedElementTransitionManager.swift
//  SharedElementTransition
//
//  Created by Victor Samuel Cuaca on 02/11/20.
//

import UIKit

class SharedElementTransitionManager: NSObject {
    
    private let TRANSITION_DURATION: TimeInterval = Constants.SHARED_TRANSITION_ANIMATION_DURATION
    private let SHRINK_DURATION: TimeInterval = Constants.SHARED_TRANSITION_ANIMATION_DURATION * 0.1
    private let SHRINK_SCALE: CGFloat = Constants.SHARED_TRANSITION_SHRINK_SCALE
    
    private var EXPAND_CONTRACT_DURATION: TimeInterval {
        return TRANSITION_DURATION - SHRINK_DURATION
    }
    
    private var transition: TransitionType = .present
    
    // MARK: - Supporting Views for Shared Element Transition
    private lazy var blurEffectView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blur)
        return blurView
    }()
    
    private lazy var backdropView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var expandingBottomBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
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
        let cardViewCopy = AppCardView(appCard: appCard, appCardState: transition.next.appCardState)
        return cardViewCopy
    }
}

// MARK: - UIViewController Animated Transitioning
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
         
        // For some reason when embedded inside a tab bar controller, the .from vc of the transition is recognized as the tab bar controller, not the Today vc. So need to cast .from vc into a tab bar controller then cast it again to Today vc
        guard let tabBarController = (transition == .present) ? (fromVC as? UITabBarController) : (toVC as? UITabBarController),
              let todayVC = tabBarController.selectedViewController as? TodayVC,
              let detailVC = (transition == .present) ? (toVC as? DetailVC) : (fromVC as? DetailVC),
              let appCardView = todayVC.getSelectedAppCardView(),
              let appCard = appCardView.appCard,
              let tabBarCopy = tabBarController.tabBar.createCopy() as? UITabBar,
              let originalTabBarFrame = todayVC.originalTabBarFrame
        else {
            transitionContext.completeTransition(false)
            return
        }
             
        // Create a copy of the selected app card view with the same frame as the copied app card view
        let appCardViewCopy = createAppCardViewCopy(appCardView: appCardView, withModel: appCard)
        let absoluteAppCardViewFrame = appCardView.convert(appCardView.frame, to: nil)
        appCardViewCopy.frame = (transition == .present) ? absoluteAppCardViewFrame :
                                                           CGRect(x: 0, y: 0, width: appCardView.frame.width, height: Constants.APP_CARD_EXPANDED_HEIGHT)
        appCardViewCopy.layoutIfNeeded()
        containerView.addSubview(appCardViewCopy)
         
        // Initial expanding bottom background view setup. If dismiss, inset top frame by app card view height to hide the background view sticking up at the top of the app card while dismissing
        expandingBottomBackgroundView.frame = (transition == .present) ? appCardViewCopy.containerView.frame : containerView.frame.inset(by: UIEdgeInsets(top: appCardViewCopy.frame.height, left: 0, bottom: 0, right: 0))
        expandingBottomBackgroundView.layer.cornerRadius = transition.cornerRadius
        expandingBottomBackgroundView.backgroundColor = .systemBackground
        appCardViewCopy.insertSubview(expandingBottomBackgroundView, aboveSubview: appCardViewCopy.shadowView)

        // Initial tab bar copy setup
        let hiddenTabBarFrame = originalTabBarFrame.offsetBy(dx: 0, dy: 100)
        tabBarCopy.frame = (transition == .present) ? originalTabBarFrame : hiddenTabBarFrame
        containerView.addSubview(tabBarCopy)
        containerView.layoutIfNeeded()
        
        // Hide original app card view and original tab bar. Hide tab bar using opacity because issue with collectionview bottom inset ignoring tab bar when it is hidden
        appCardView.isHidden = true
        tabBarController.tabBar.layer.opacity = 0
                
        if transition == .present {
            containerView.addSubview(detailVC.view)
            detailVC.view.isHidden = true
            
            startTransition(appCardView: appCardViewCopy, tabBar: tabBarCopy, containerView: containerView, yAppCardTarget: 0, yTabBarTarget: hiddenTabBarFrame.origin.y) {
                detailVC.view.isHidden = false
                appCardView.isHidden = false
                tabBarController.tabBar.layer.opacity = 1

                appCardViewCopy.removeFromSuperview()
                self.expandingBottomBackgroundView.removeFromSuperview()
                
                transitionContext.completeTransition(true)
            }
        } else {
            startTransition(appCardView: appCardViewCopy, tabBar: tabBarCopy, containerView: containerView, yAppCardTarget: absoluteAppCardViewFrame.origin.y, yTabBarTarget: originalTabBarFrame.origin.y) {
                appCardView.isHidden = false
                tabBarController.tabBar.layer.opacity = 1

                appCardViewCopy.removeFromSuperview()
                self.expandingBottomBackgroundView.removeFromSuperview()
                
                transitionContext.completeTransition(true)
            }
        }
    }
}

// MARK: - UIViewController Transitioning Delegate
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

// MARK: - Transition Animations
extension SharedElementTransitionManager {
    
    private func createShrinkAnimator(for appCardView: AppCardView) -> UIViewPropertyAnimator {
        return UIViewPropertyAnimator(duration: SHRINK_DURATION, curve: .easeOut) {
            appCardView.transform = CGAffineTransform(scaleX: self.SHRINK_SCALE, y: self.SHRINK_SCALE)
        }
    }
    
    private func createExpandContractAnimators(for appCardView: AppCardView, tabBar: UITabBar, in containerView: UIView, yOriginAppCard: CGFloat, yOriginTabBar: CGFloat) -> [UIViewPropertyAnimator] {
        let springTiming = UISpringTimingParameters(dampingRatio: 0.7, initialVelocity: CGVector(dx: 0, dy: 4))
        let springAnimator = UIViewPropertyAnimator(duration: EXPAND_CONTRACT_DURATION, timingParameters: springTiming)
        
        springAnimator.addAnimations {
            // Set app card view copy target state
            appCardView.frame.origin.y = yOriginAppCard
            appCardView.containerView.layer.cornerRadius = self.transition.next.cornerRadius
            appCardView.updateLayout(for: self.transition.appCardState)
        }
        
        let nonSpringAnimator = UIViewPropertyAnimator(duration: EXPAND_CONTRACT_DURATION, dampingRatio: 1) {
            // Set app card view copy target height
            appCardView.transform = .identity
            appCardView.frame = CGRect(x: appCardView.frame.origin.x, y: yOriginAppCard, width: appCardView.frame.width, height: self.transition.appCardHeight)

            // Set expanding bottom background view target state
            self.expandingBottomBackgroundView.frame = (self.transition == .present) ? containerView.frame : appCardView.containerView.frame
            self.expandingBottomBackgroundView.layer.cornerRadius = self.transition.next.cornerRadius
            self.expandingBottomBackgroundView.backgroundColor = self.transition.expandingBottomBackgroundViewColor

            // Set blur and backdrop view target state
            self.blurEffectView.alpha = self.transition.blurAlpha
            self.backdropView.alpha = self.transition.backdropAlpha
            
            // Set tab bar copy target state
            tabBar.frame.origin.y = yOriginTabBar
        }
        
        return [springAnimator, nonSpringAnimator]
    }
    
    private func startTransition(appCardView: AppCardView, tabBar: UITabBar, containerView: UIView, yAppCardTarget: CGFloat, yTabBarTarget: CGFloat , completion: @escaping () -> Void) {
        
        let expandContractAnimators = createExpandContractAnimators(for: appCardView, tabBar: tabBar, in: containerView, yOriginAppCard: yAppCardTarget, yOriginTabBar: yTabBarTarget)

        expandContractAnimators.first?.addCompletion { _ in
            completion()
        }
        
        if transition == .present {
            let shrinkAnimator = createShrinkAnimator(for: appCardView)
            
            shrinkAnimator.addCompletion { _ in
                expandContractAnimators.forEach({ $0.startAnimation() })
            }
            
            shrinkAnimator.startAnimation()
        } else {
            expandContractAnimators.forEach({ $0.startAnimation() })
        }
    }
}

// MARK: - Transition Type
extension SharedElementTransitionManager {
    
    enum TransitionType {
        case present
        case dismiss
        
        var blurAlpha: CGFloat { return self == .present ? 1 : 0 }
        var backdropAlpha: CGFloat { return self == .present ? 0.5 : 0 }
        var closeAlpha: CGFloat { return self == .present ? 1 : 0 }
        var cornerRadius: CGFloat { return self == .present ? Constants.APP_CARD_CORNER_RADIUS : 0 }
        var appCardState: AppCardState { return self == .present ? .expanded : .card }
        var appCardHeight: CGFloat { return self == .present ? Constants.APP_CARD_EXPANDED_HEIGHT : Constants.APP_CARD_HEIGHT }
        var expandingBottomBackgroundViewColor: UIColor { return self == .present ? .systemBackground : .clear }
        var next: TransitionType { return self == .present ? .dismiss : .present }
    }
}
