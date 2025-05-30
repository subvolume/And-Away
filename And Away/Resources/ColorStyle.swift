// ColorStyle.swift
import SwiftUI

extension Color {
    // MARK: - Semantic Colors
    
    // Primary color - Black in light mode, White in dark mode
    static let primary = Color(
        light: Color.black100,     // #1A1C1E
        dark: Color.white100       // White
    )
    
    // Secondary color - Grey
    static let secondary = Color(
        light: Color.grey100,      // #77818C
        dark: Color.smoke100       // Lighter for dark mode
    )
    
    // Tertiary color - Smoke
    static let tertiary = Color(
        light: Color.smoke100,     // #A5ACB6
        dark: Color.grey100        // Darker for dark mode
    )
    
    // Invert color - White in light mode, Black in dark mode
    static let invert = Color(
        light: Color.white100,     // #FFFFFF
        dark: Color.black100       // #1A1C1E
    )
    
    // MARK: - Background Colors
    
    // Primary background - White in light mode, Dark in dark mode
    static let backgroundPrimary = Color(
        light: Color.white100,                                    // #FFFFFF
        dark: Color(red: 18/255, green: 18/255, blue: 18/255)   // #121212
    )
    
    // Secondary background - Grey 15% opacity
    static let backgroundSecondary = Color(
        light: Color.grey15,       // #77818C 15%
        dark: Color.smoke15        // Lighter gray 15%
    )
    
    // Tertiary background - Smoke 15% opacity
    static let backgroundTertiary = Color(
        light: Color.smoke15,      // #A5ACB6 15%
        dark: Color.grey15         // Darker gray 15%
    )
    
    // Invert background - White/Black 15% opacity
    static let backgroundInvert = Color(
        light: Color.white15,      // White 15%
        dark: Color.black15        // Black 15%
    )
    
    // Selected background - Azure
    static let backgroundSelected = Color(
        light: Color.azure100,     // #128DFF
        dark: Color.azure100       // Same blue for dark mode
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