//
//  PillButton.swift
//  And Away
//
//  Created by Oliver Lukman on 29/05/2025.
//

import SwiftUI

// MARK: - Layout Style
enum PillButtonLayoutStyle {
    case horizontal
    case vertical
}

struct PillButton: View {
    // MARK: - Properties
    let text: String?
    let icon: String?
    let defaultTextColor: Color
    let defaultBackgroundColor: Color
    let selectedTextColor: Color
    let selectedBackgroundColor: Color
    let verticalPadding: CGFloat
    let layoutStyle: PillButtonLayoutStyle
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
        layoutStyle: PillButtonLayoutStyle = .horizontal,
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
        self.layoutStyle = layoutStyle
        self.isSelected = isSelected
        self.action = action
    }
    
    // MARK: - Body
    var body: some View {
        let currentTextColor = isSelected ? selectedTextColor : defaultTextColor
        let currentBackgroundColor = isSelected ? selectedBackgroundColor : defaultBackgroundColor
        
        let content = Group {
            if layoutStyle == .vertical {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(FontStyle.button)
                            .foregroundColor(currentTextColor)
                    }
                    if let text = text {
                        Text(text)
                            .button()
                            .foregroundColor(currentTextColor)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                }
            } else {
                HStack(spacing: Spacing.xs) {
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
            }
        }
        
        // Icon-only buttons are circular, others are capsule-shaped
        if text == nil && icon != nil && layoutStyle == .horizontal {
            content
                .frame(width: 32, height: 32, alignment: .center)
                .background(currentBackgroundColor)
                .clipShape(Circle())
                .onTapGesture { action() }
        } else if layoutStyle == .vertical {
            content
                .frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
                .padding(.horizontal, Spacing.s)
                .padding(.vertical, Spacing.xs)
                .background(currentBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .onTapGesture { action() }
        } else {
            content
                .padding(.horizontal, Spacing.s)
                .frame(height: 32, alignment: .center)
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
    
    /// Text + Icon button (horizontal layout)
    static func textIcon(
        text: String,
        icon: String,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) -> PillButton {
        PillButton(text: text, icon: icon, isSelected: isSelected, action: action)
    }
    
    /// Icon above text button (vertical layout)
    static func iconAboveText(
        text: String,
        icon: String,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) -> PillButton {
        PillButton(text: text, icon: icon, layoutStyle: .vertical, isSelected: isSelected, action: action)
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
    @State private var iconAboveTextSelected = false
    
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
            
            // Text + Icon (horizontal)
            PillButton.textIcon(text: "Favorite", icon: "star.fill", isSelected: textIconSelected) {
                textIconSelected.toggle()
                print("Favorite tapped - selected: \(textIconSelected)")
            }
            
            // Icon above text (vertical)
            PillButton.iconAboveText(text: "Share", icon: "square.and.arrow.up", isSelected: iconAboveTextSelected) {
                iconAboveTextSelected.toggle()
                print("Share tapped - selected: \(iconAboveTextSelected)")
            }
        }
    }
} 
