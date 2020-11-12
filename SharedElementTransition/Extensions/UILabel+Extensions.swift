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
    
    /// Applies a leading bold attribute to the label's text
    /// - Parameter string: String representing the delimiter of the bold text
    func applyLeadingBoldAttribute(separatedBy string: String) {
        guard let separatedText = self.text?.components(separatedBy: string),
              let font = self.font,
              separatedText.count >= 2 else { return }
        
        let cleanedText = "\(separatedText[0])\(separatedText[1])"
        
        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.secondaryLabel
        ]
        let attributedString = NSMutableAttributedString(string: cleanedText, attributes: regularAttributes)
        
        let boldFontAttribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: font.pointSize),
            .foregroundColor: UIColor.label
        ]
        let range = (cleanedText as NSString).range(of: separatedText[0])
        attributedString.addAttributes(boldFontAttribute, range: range)
        
        self.attributedText = attributedString
    }
}
