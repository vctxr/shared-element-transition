//
//  CloseButton.swift
//  SharedElementTransition
//
//  Created by Victor Samuel Cuaca on 08/11/20.
//

import UIKit

class CloseButton: UIButton {
    
    var currentAppearance: Appearance?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureButton()
    }
    
    // MARK: - Functions
    
    /// Animates the change of close button appearance if needed.
    /// - Parameter appearance: Appearance enum representing the initial close button light/dark styles
    func animateAppearanceIfNeeded(for appearance: Appearance) {
        guard currentAppearance != appearance else { return }

        currentAppearance = appearance
        
        let backgroundColor: UIColor
        let tintColor: UIColor
        
        switch appearance {
        case .light:
            backgroundColor = .closeButtonBackgroundLight
            tintColor = .closeButtonTintLight
        case .dark:
            backgroundColor = .closeButtonBackgroundDark
            tintColor = .closeButtonTintDark
        }
        
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = backgroundColor
            self.tintColor = tintColor
        }
    }
    
    /// Sets the initial appearance for the close button.
    /// - Parameter appearance: Appearance enum representing the initial close button light/dark styles
    func setInitialAppearance(appearance: Appearance) {
        currentAppearance = appearance
        
        switch appearance {
        case .light:
            backgroundColor = .closeButtonBackgroundLight
            tintColor = .closeButtonTintLight
        case .dark:
            backgroundColor = .closeButtonBackgroundDark
            tintColor = .closeButtonTintDark
        }
    }
}

// MARK: - Configurations
extension CloseButton {
    
    private func configureButton() {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)
        setImage(UIImage(systemName: "xmark", withConfiguration: imageConfiguration), for: .normal)
        alpha = Constants.APP_CARD_CLOSE_BUTTON_ALPHA
        layer.cornerRadius = Constants.APP_CARD_CLOSE_BUTTON_SIZE.width / 2
    }
}
