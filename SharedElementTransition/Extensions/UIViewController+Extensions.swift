//
//  UIViewController+Extensions.swift
//  SharedElementTransition
//
//  Created by Victor Samuel Cuaca on 08/11/20.
//

import UIKit

extension UIViewController {
    
    var isDarkMode: Bool {
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            return false
        case .dark:
            return true
        default:
            return false
        }
    }
}
