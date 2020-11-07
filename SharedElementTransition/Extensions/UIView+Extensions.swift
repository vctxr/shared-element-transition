//
//  UIView+Extensions.swift
//  SharedElementTransition
//
//  Created by Victor Samuel Cuaca on 02/11/20.
//

import UIKit

extension UIView {
    
    /// Creates a copy by value of the specified view.
    /// - Returns: A copy by value of the specified view
    func createCopy<T: UIView>() -> T {
        do {
            let copiedView = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false))
            return copiedView as! T
        } catch {
            return self as! T
        }
    }
    
    /// Removes the specified views from the view hierarchy.
    /// - Parameter views: Array of UIViews representing the views to be removed from the view hierarchy
    func removeViewsFromSuperview(views: [UIView]) {
        views.forEach({ $0.removeFromSuperview() })
    }
    
    /// Shows all shadow of the view if there is any.
    func showAllShadows(opacity: Float, radius: CGFloat, offset: CGSize) {
        guard layer.shadowOpacity == 0 else { return }
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
    }
    
    /// Hides all the shadows of the view if there is any.
    func hideAllShadows() {
        guard layer.shadowOpacity != 0 else { return }
        
        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowOpacity = 0
        layer.shadowRadius = 0
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}

// MARK: - Animations
extension UIView {
    
    /// Animate the translation of the view.
    /// - Parameters:
    ///   - x: CGFloat representing the x translation amount
    ///   - y: CGFloat representing the y translation amount
    func animateTranslation(translationX x: CGFloat, y: CGFloat) {
        UIViewPropertyAnimator(duration: Constants.SHARED_TRANSITION_ANIMATION_DURATION * 0.7, dampingRatio: 1) {
            self.frame = self.frame.offsetBy(dx: x, dy: y)
        }.startAnimation()
    }
    
    /// Animate the tranlsation of the view.
    /// - Parameter newFrame: CGRect representing the desired target frame
    func animateTranslation(targetFrame: CGRect) {
        UIViewPropertyAnimator(duration: Constants.SHARED_TRANSITION_ANIMATION_DURATION * 0.7, dampingRatio: 1) {
            self.frame = targetFrame
        }.startAnimation()
    }
}
