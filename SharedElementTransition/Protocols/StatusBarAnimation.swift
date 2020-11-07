//
//  StatusBarAnimation.swift
//  SharedElementTransition
//
//  Created by Victor Samuel Cuaca on 08/11/20.
//

import UIKit

/// Properties and methods for animating status bar appearances.
protocol StatusBarAnimation: AnyObject {
    var statusBarShouldBeHidden: Bool { get set }
    var statusBarAnimationStyle: UIStatusBarAnimation { get set }
}

extension StatusBarAnimation where Self: UIViewController {
    
    /// Animates the status bar appearance.
    /// - Parameters:
    ///   - hidden: Boolean representing wether or not the status bar should be hidden
    ///   - duration: TimeInterval representing the duration of the animation
    ///   - completion: Completion handler to handle animation complete
    func animateStatusBarAppearance(hidden: Bool, duration: TimeInterval, completion: (() -> Void)? = nil) {
        statusBarShouldBeHidden = hidden
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
        animator.addCompletion { (_) in
            completion?()
        }
        
        animator.startAnimation()
    }
}
