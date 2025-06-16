//
//  PillButton.swift
//  And Away
//
//  Created by Oliver Lukman on 29/05/2025.
//

import SwiftUI

struct PillButton: View {
    // MARK: - Properties
    let text: String?
    let icon: String?
    let defaultTextColor: Color
    let defaultBackgroundColor: Color
    let selectedTextColor: Color
    let selectedBackgroundColor: Color
    let verticalPadding: CGFloat
    let isSelected: Bool
    let action: () -> Void
    
    // MARK: - Initializer
    init(
        text: String? = nil,
        icon: String? = nil,
        defaultTextColor: Color = .secondary,
        defaultBackgroundColor: Color = .backgroundPrimary.opacity(0.8),
        selectedTextColor: Color = .invert,
        selectedBackgroundColor: Color = .backgroundSelected,
        verticalPadding: CGFloat = Spacing.xs,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.icon = icon
        self.defaultTextColor = defaultTextColor
        self.defaultBackgroundColor = defaultBackgroundColor
        self.selectedTextColor = selectedTextColor
        self.selectedBackgroundColor = selectedBackgroundColor
        self.verticalPadding = verticalPadding
        self.isSelected = isSelected
        self.action = action
    }
    
    // MARK: - Body
    var body: some View {
        let currentTextColor = isSelected ? selectedTextColor : defaultTextColor
        let currentBackgroundColor = isSelected ? selectedBackgroundColor : defaultBackgroundColor
        
        let content = HStack(spacing: Spacing.xs) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(currentTextColor)
            }
            if let text = text {
                Text(text)
                    .button()
                    .foregroundColor(currentTextColor)
            }
        }
        
        // Icon-only buttons are circular, others are capsule-shaped
        if text == nil && icon != nil {
            content
                .frame(width: 48, height: 48, alignment: .center)
                .background(currentBackgroundColor)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.backgroundPrimary, lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 4)
                .onTapGesture { action() }
        } else {
            content
                .padding(.horizontal, Spacing.m)
                .frame(height: 48, alignment: .center)
                .background(currentBackgroundColor)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.backgroundPrimary, lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 4)
                .onTapGesture { action() }
        }
    }
}

// MARK: - Convenience Initializers
extension PillButton {
    /// Text-only button
    static func text(
        _ text: String,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) -> PillButton {
        PillButton(text: text, isSelected: isSelected, action: action)
    }
    
    /// Icon-only button
    static func icon(
        _ icon: String,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) -> PillButton {
        PillButton(icon: icon, isSelected: isSelected, action: action)
    }
    
    /// Text + Icon button
    static func textIcon(
        text: String,
        icon: String,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) -> PillButton {
        PillButton(text: text, icon: icon, isSelected: isSelected, action: action)
    }
}

// MARK: - Preview
struct PillButton_Previews: PreviewProvider {
    static var previews: some View {
        InteractivePillButtonPreview()
            .padding()
            .background(Color.backgroundTertiary)
            .previewLayout(.sizeThatFits)
    }
}

private struct InteractivePillButtonPreview: View {
    @State private var textSelected = false
    @State private var iconSelected = false
    @State private var textIconSelected = false
    
    var body: some View {
        VStack(spacing: Spacing.m) {
            // Text only
            PillButton.text("Text Button", isSelected: textSelected) {
                textSelected.toggle()
                print("Text tapped - selected: \(textSelected)")
            }
            
            // Icon only
            PillButton.icon("heart.fill", isSelected: iconSelected) {
                iconSelected.toggle()
                print("Heart tapped - selected: \(iconSelected)")
            }
            
            // Text + Icon
            PillButton.textIcon(text: "Favorite", icon: "star.fill", isSelected: textIconSelected) {
                textIconSelected.toggle()
                print("Favorite tapped - selected: \(textIconSelected)")
            }
        }
    }
} 
