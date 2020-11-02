//
//  UIView+Extensions.swift
//  SharedElementTransition
//
//  Created by Victor Samuel Cuaca on 02/11/20.
//

import UIKit

extension UIView {
    
    func copyView<T: UIView>() -> T {
        do {
            let copiedView = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false))
            return copiedView as! T
        } catch {
            return self as! T
        }
    }
    
    static func animateTabBarFrames(tabBar: UITabBar?, newFrame: CGRect?) {
        guard let tabBar = tabBar,
              let newFrame = newFrame else { return }
        
        UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1) {
            tabBar.frame = newFrame
        }.startAnimation()
    }
}
