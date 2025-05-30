//
//  FontStyle.swift
//  And Away
//
//  Created by Oliver Lukman on 29/05/2025.
//

import SwiftUI

struct FontStyle {
    // MARK: - Font Family Name
    static let fontFamily = "Plus Jakarta Sans"
    
    // MARK: - Font Weights
    static let light = Font.custom(fontFamily, size: 16).weight(.light)
    static let regular = Font.custom(fontFamily, size: 16).weight(.regular)
    static let medium = Font.custom(fontFamily, size: 16).weight(.medium)
    static let semiBold = Font.custom(fontFamily, size: 16).weight(.semibold)
    static let bold = Font.custom(fontFamily, size: 16).weight(.bold)
    
    // MARK: - Text Styles with Sizes
    static let title1 = Font.custom(fontFamily, size: 28).weight(.bold)
    static let title2 = Font.custom(fontFamily, size: 24).weight(.semibold)
    static let title3 = Font.custom(fontFamily, size: 20).weight(.semibold)
    
    static let headline = Font.custom(fontFamily, size: 18).weight(.semibold)
    static let body = Font.custom(fontFamily, size: 16).weight(.regular)
    static let bodyMedium = Font.custom(fontFamily, size: 16).weight(.medium)
    static let callout = Font.custom(fontFamily, size: 15).weight(.regular)
    static let subheadline = Font.custom(fontFamily, size: 14).weight(.regular)
    static let footnote = Font.custom(fontFamily, size: 13).weight(.regular)
    static let caption = Font.custom(fontFamily, size: 12).weight(.regular)
    static let caption2 = Font.custom(fontFamily, size: 11).weight(.regular)
    
    // MARK: - Italic Styles
    static let bodyItalic = Font.custom(fontFamily, size: 16).weight(.regular).italic()
    static let footnoteItalic = Font.custom(fontFamily, size: 13).weight(.regular).italic()
}

// MARK: - SwiftUI Font Extension
extension Font {
    static func plusJakarta(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return Font.custom("Plus Jakarta Sans", size: size).weight(weight)
    }
} 