// ColorStyle.swift
import SwiftUI

extension Color {
    // Primary color - #1A1C1E in light mode, White in dark mode
    static let primary = Color(
        light: Color(red: 26/255, green: 28/255, blue: 30/255), // #1A1C1E
        dark: Color(red: 1.0, green: 1.0, blue: 1.0)           // White
    )
    
    // Secondary color - #77818C
    static let secondary = Color(
        light: Color(red: 119/255, green: 129/255, blue: 140/255), // #77818C
        dark: Color(red: 170/255, green: 180/255, blue: 190/255)   // Lighter for dark mode
    )
    
    // Tertiary color - #A5ACB6
    static let tertiary = Color(
        light: Color(red: 165/255, green: 172/255, blue: 182/255), // #A5ACB6
        dark: Color(red: 119/255, green: 129/255, blue: 140/255)   // Darker for dark mode
    )
    
    // Invert color - #FFFFFF in light mode, Black in dark mode
    static let invert = Color(
        light: Color(red: 1.0, green: 1.0, blue: 1.0),         // #FFFFFF
        dark: Color(red: 26/255, green: 28/255, blue: 30/255)  // #1A1C1E
    )
}

// Helper extension to create adaptive colors
extension Color {
    init(light: Color, dark: Color) {
        self.init(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(dark)
            default:
                return UIColor(light)
            }
        })
    }
} 