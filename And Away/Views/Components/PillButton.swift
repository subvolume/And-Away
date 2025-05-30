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
    
    // Customizable colors
    let defaultTextColor: Color
    let defaultBackgroundColor: Color
    let selectedTextColor: Color
    let selectedBackgroundColor: Color
    
    let verticalPadding: CGFloat
    let isSelected: Bool
    let action: () -> Void
    
    // MARK: - Initializers
    
    /// Creates a button with both text and icon
    init(
        text: String,
        icon: String,
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
    
    /// Creates a text-only button
    init(
        text: String,
        defaultTextColor: Color = .secondary,
        defaultBackgroundColor: Color = .backgroundTertiary,
        selectedTextColor: Color = .invert,
        selectedBackgroundColor: Color = .backgroundSelected,
        verticalPadding: CGFloat = Spacing.xs,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.icon = nil
        self.defaultTextColor = defaultTextColor
        self.defaultBackgroundColor = defaultBackgroundColor
        self.selectedTextColor = selectedTextColor
        self.selectedBackgroundColor = selectedBackgroundColor
        self.verticalPadding = verticalPadding
        self.isSelected = isSelected
        self.action = action
    }
    
    /// Creates an icon-only button
    init(
        icon: String,
        defaultTextColor: Color = .secondary,
        defaultBackgroundColor: Color = .backgroundTertiary,
        selectedTextColor: Color = .invert,
        selectedBackgroundColor: Color = .backgroundSelected,
        verticalPadding: CGFloat = Spacing.xs,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) {
        self.text = nil
        self.icon = icon
        self.defaultTextColor = defaultTextColor
        self.defaultBackgroundColor = defaultBackgroundColor
        self.selectedTextColor = selectedTextColor
        self.selectedBackgroundColor = selectedBackgroundColor
        self.verticalPadding = verticalPadding
        self.isSelected = isSelected
        self.action = action
    }
    
    /// Creates a rotating icon button that transitions from + to x with 90° rotation
    init(
        defaultTextColor: Color = .secondary,
        defaultBackgroundColor: Color = .backgroundTertiary,
        selectedTextColor: Color = .invert,
        selectedBackgroundColor: Color = .backgroundSelected,
        verticalPadding: CGFloat = Spacing.xs,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) {
        self.text = nil
        self.icon = "plus" // Will be overridden in body based on state
        self.defaultTextColor = defaultTextColor
        self.defaultBackgroundColor = defaultBackgroundColor
        self.selectedTextColor = selectedTextColor
        self.selectedBackgroundColor = selectedBackgroundColor
        self.verticalPadding = verticalPadding
        self.isSelected = isSelected
        self.action = action
    }
    
    // MARK: - Properties for rotation behavior
    private var isRotatingButton: Bool {
        // Detect if this is the rotating + to x button by checking if icon is "plus"
        return icon == "plus"
    }
    
    private var currentIcon: String {
        if isRotatingButton {
            return "xmark"
        }
        return icon ?? "questionmark"
    }
    
    private var rotationAngle: Double {
        if isRotatingButton {
            return isSelected ? -45 : 0
        }
        return 0
    }
    
    // MARK: - Body
    var body: some View {
        let currentTextColor = isRotatingButton ? defaultTextColor : (isSelected ? selectedTextColor : defaultTextColor)
        let currentBackgroundColor = isRotatingButton ? defaultBackgroundColor : (isSelected ? selectedBackgroundColor : defaultBackgroundColor)
        
        let labelContent = HStack(spacing: Spacing.xs) {
            if icon != nil {
                Image(systemName: currentIcon)
                    .font(FontStyle.button)
                    .foregroundColor(currentTextColor)
                    .rotationEffect(.degrees(rotationAngle))
                    .animation(.easeInOut(duration: 0.3), value: isSelected)
            }
            if let text = text {
                Text(text)
                    .button()
                    .foregroundColor(currentTextColor)
            }
        }

        Button(action: action) {
            if text == nil && icon != nil { // Icon-only button: Make it a circle
                labelContent
                    .frame(width: 15, height: 15, alignment: .center)
                    .padding(verticalPadding)
                    .background(currentBackgroundColor)
                    .clipShape(Circle())
            } else { // Button with text
                labelContent
                    .padding(.vertical, verticalPadding)
                    .padding(.horizontal, Spacing.s)
                    .background(currentBackgroundColor)
                    .clipShape(Capsule())
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

// Helper View for interactive button previews
private struct InteractivePillButtonPreviewWrapper: View {
    let title: String
    let initialIcon: String?
    let selectedIcon: String? // Optional, for icons that change
    let initiallySelected: Bool
    let changesContent: Bool // If true, text/icon might change based on state
    let verticalPadding: CGFloat // Allow passing vertical padding

    @State private var isSelectedState: Bool

    init(title: String, initialIcon: String? = nil, selectedIcon: String? = nil, initiallySelected: Bool, changesContent: Bool = false, verticalPadding: CGFloat = Spacing.xs) {
        self.title = title
        self.initialIcon = initialIcon
        self.selectedIcon = selectedIcon ?? initialIcon
        self.initiallySelected = initiallySelected
        self._isSelectedState = State(initialValue: initiallySelected)
        self.changesContent = changesContent
        self.verticalPadding = verticalPadding
    }

    var body: some View {
        let actualText: String = changesContent ? "\(title) \(isSelectedState ? "(On)" : "(Off)")" : title
        let iconNameToShow: String? = changesContent ? (isSelectedState ? selectedIcon : initialIcon) : initialIcon

        // Define the action closure once
        let buttonAction = {
            isSelectedState.toggle()
            print("'\(title)' button toggled to: \(isSelectedState)")
        }

        // Conditionally call the appropriate PillButton initializer
        if let concreteIconName = iconNameToShow {
            // We have an icon, so use the initializer for text + icon
            PillButton(
                text: actualText,
                icon: concreteIconName, // Now non-optional
                defaultTextColor: .secondary, // Explicitly passing to match initializer, defaults are used by PillButton
                defaultBackgroundColor: .backgroundTertiary,
                selectedTextColor: .invert,
                selectedBackgroundColor: .backgroundSelected,
                verticalPadding: verticalPadding,
                isSelected: isSelectedState,
                action: buttonAction
            )
        } else if title.contains("Rotating") {
            // Use the rotating button initializer
            PillButton(
                defaultTextColor: .secondary,
                defaultBackgroundColor: .backgroundTertiary,
                selectedTextColor: .invert,
                selectedBackgroundColor: .backgroundSelected,
                verticalPadding: verticalPadding,
                isSelected: isSelectedState,
                action: buttonAction
            )
        } else {
            // No icon, so use the initializer for text-only
            PillButton(
                text: actualText,
                defaultTextColor: .secondary,
                defaultBackgroundColor: .backgroundTertiary,
                selectedTextColor: .invert,
                selectedBackgroundColor: .backgroundSelected,
                verticalPadding: verticalPadding,
                isSelected: isSelectedState,
                action: buttonAction
            )
        }
    }
}

struct PillButton_Previews: PreviewProvider {
    // Removed static @State variables as they are now managed by InteractivePillButtonPreviewWrapper

    static var previews: some View {
        VStack(spacing: Spacing.m) {
            // Interactive Toggle Button (changes text, icon, and state)
            InteractivePillButtonPreviewWrapper(
                title: "Interactive",
                initialIcon: "circle.fill",
                selectedIcon: "checkmark.circle.fill",
                initiallySelected: false,
                changesContent: true
            )
            
            // Rotating + to x button (new!)
            InteractivePillButtonPreviewWrapper(
                title: "Rotating +/× (Tap Me)",
                initiallySelected: false
            )
            
            // Default state (now interactive)
            InteractivePillButtonPreviewWrapper(
                title: "Default (Tap Me)",
                initiallySelected: false
            )
            
            // Selected state (now interactive)
            InteractivePillButtonPreviewWrapper(
                title: "Selected (Tap Me)",
                initiallySelected: true
            )
            
            // Icon only - default (remains static for clarity)
            PillButton(icon: "heart.fill") { 
                print("Icon default tapped")
            }
            
            // Icon only - selected (remains static for clarity)
            PillButton(icon: "heart.fill", isSelected: true) {
                print("Icon selected tapped")
            }
            
            // Text + Icon - default (remains static for clarity)
            PillButton(text: "Favorite", icon: "star.fill") { 
                print("Text + Icon default tapped")
            }
            
            // Text + Icon - selected (remains static for clarity)
            PillButton(text: "Favorited", icon: "star.fill", isSelected: true) {
                print("Text + Icon selected tapped")
            }
            
            // Example with taller padding and selected (now interactive using the wrapper)
            InteractivePillButtonPreviewWrapper(
                title: "Tall (Tap Me)",
                initiallySelected: true, // Start selected for this example
                verticalPadding: Spacing.m
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .background(Color.backgroundPrimary) // To see adaptive colors better
    }
} 