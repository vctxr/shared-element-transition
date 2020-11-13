//
//  Constants.swift
//  SharedElementTransition
//
//  Created by Victor Samuel Cuaca on 07/11/20.
//

import UIKit

/// A struct that contains all app constants value.
struct Constants {
    static let APP_CARD_HEIGHT: CGFloat = 450
    static let APP_CARD_EXPANDED_HEIGHT: CGFloat = 550
    
    static let APP_CARD_CLOSE_BUTTON_SIZE: CGSize = CGSize(width: 30, height: 30)
    static let APP_CARD_CLOSE_BUTTON_ALPHA: CGFloat = 0.9
    
    static let APP_CARD_CORNER_RADIUS: CGFloat = 10
    static let APP_CARD_SHADOW_OPACITY: Float = 0.15
    static let APP_CARD_SHADOW_RADIUS: CGFloat = 10
    static let APP_CARD_SHADOW_OFFSET: CGSize = CGSize(width: 0, height: 12)
    
    static let SHARED_TRANSITION_ANIMATION_DURATION: TimeInterval = 0.8
    static let SHARED_TRANSITION_SHRINK_SCALE: CGFloat = 0.97
    
    static let STATUS_BAR_TRANSITION_ANIMATION_DURATION: TimeInterval = 0.4
    
    static let DISMISS_TRESHOLD: CGFloat = 100
    static let MIN_SCALE: CGFloat = 0.85
}
