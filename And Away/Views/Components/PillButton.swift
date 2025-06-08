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
        defaultBackgroundColor: Color = .backgroundTertiary,
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
                    .font(FontStyle.button)
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
                .frame(width: 15, height: 15, alignment: .center)
                .padding(verticalPadding)
                .background(currentBackgroundColor)
                .clipShape(Circle())
                .onTapGesture { action() }
        } else {
            content
                .padding(.vertical, verticalPadding)
                .padding(.horizontal, Spacing.s)
                .background(currentBackgroundColor)
                .clipShape(Capsule())
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
            .background(Color.backgroundPrimary)
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
