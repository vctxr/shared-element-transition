//
//  UIFont+Extensions.swift
//  SharedElementTransition
//
//  Created by Victor Samuel Cuaca on 01/11/20.
//

import UIKit

extension UIFont {
    
    /// Returns the font with the specified weight.
    /// - Parameter weight: UIFont.Weight representing the desired font weight
    /// - Returns: UIFont of the specified weight
    func with(weight: UIFont.Weight) -> UIFont {
        return UIFont.systemFont(ofSize: pointSize, weight: weight)
    }
}
