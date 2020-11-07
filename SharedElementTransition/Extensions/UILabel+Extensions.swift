//
//  UILabel+Extensions.swift
//  SharedElementTransition
//
//  Created by Victor Samuel Cuaca on 01/11/20.
//

import UIKit

extension UILabel {
    
    /// Applies dynamic sizing to the given label with the specified font.
    func applyDynamicType() {
        font = UIFontMetrics.default.scaledFont(for: font)
        adjustsFontForContentSizeCategory = true
    }
    
    /// Applies the label's text line spacing with the desired spacing. Only call this function after the label's text is set, otherwise the spacing will not be calculated.
    func applyLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributedString: NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        
        self.attributedText = attributedString
    }
}
