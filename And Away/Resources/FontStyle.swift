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
    
    // MARK: - Page Titles
    static let pageTitle = Font.custom(fontFamily, size: 30).weight(.bold)
    static let pageSubtitle = Font.custom(fontFamily, size: 17).weight(.medium)
    static let pageNote = Font.custom(fontFamily, size: 17).weight(.regular).italic()
    
    // MARK: - Card & List Text
    static let cardTitle = Font.custom(fontFamily, size: 16).weight(.medium)
    static let cardSubtitle = Font.custom(fontFamily, size: 16).weight(.medium)
    static let listTitle = Font.custom(fontFamily, size: 17).weight(.semibold)
    static let listSubtitle = Font.custom(fontFamily, size: 16).weight(.regular)
    static let listNote = Font.custom(fontFamily, size: 14).weight(.medium).italic()
    static let listParagraph = Font.custom(fontFamily, size: 16).weight(.regular)
    static let listDone = Font.custom(fontFamily, size: 17).weight(.medium)
    
    // MARK: - Buttons
    static let button = Font.custom(fontFamily, size: 15).weight(.semibold)
}

// MARK: - SwiftUI Font Extension
extension Font {
    static func plusJakarta(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return Font.custom("Plus Jakarta Sans", size: size).weight(weight)
    }
}

// MARK: - Text Modifiers for Letter Spacing and Line Height
extension Text {
    // Page Titles with Letter Spacing
    func pageTitle() -> some View {
        self.font(FontStyle.pageTitle)
            .kerning(0.37)
    }
    
    func pageSubtitle() -> some View {
        self.font(FontStyle.pageSubtitle)
            .kerning(0)
    }
    
    func pageNote() -> some View {
        self.font(FontStyle.pageNote)
            .kerning(-0.41)
    }
    
    // Card & List Text with Letter Spacing and Line Height
    func cardTitle() -> some View {
        self.font(FontStyle.cardTitle)
            .kerning(0)
    }
    
    func cardSubtitle() -> some View {
        self.font(FontStyle.cardSubtitle)
            .kerning(0)
    }
    
    func listTitle() -> some View {
        self.font(FontStyle.listTitle)
            .kerning(0)
    }
    
    func listSubtitle() -> some View {
        self.font(FontStyle.listSubtitle)
            .kerning(0)
    }
    
    func listNote() -> some View {
        self.font(FontStyle.listNote)
            .kerning(0)
            .lineSpacing(6) // 20pt line height - 14pt font size = 6pt line spacing
    }
    
    func listParagraph() -> some View {
        self.font(FontStyle.listParagraph)
            .kerning(0)
            .lineSpacing(10) // 26pt line height - 16pt font size = 10pt line spacing
    }
    
    func listDone() -> some View {
        self.font(FontStyle.listDone)
            .kerning(0)
            .lineSpacing(3) // 20pt line height - 17pt font size = 3pt line spacing
    }
    
    // Buttons
    func button() -> some View {
        self.font(FontStyle.button)
            .kerning(0)
    }
} 