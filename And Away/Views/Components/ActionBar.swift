import SwiftUI

enum ActionBarConfiguration {
    case initial
    case placeDetails
}

struct ActionBar: View {
    @Binding var isSearchActive: Bool
    var configuration: ActionBarConfiguration = .initial
    var onClose: (() -> Void)? = nil
    
    @State private var isBookmarked = false
    
    var body: some View {
        HStack {
            // Left button content varies by configuration
            switch configuration {
            case .initial:
                PillButton.text("Plan today", action: {})
            case .placeDetails:
                PillButton.text("Add to today", action: {})
            }

            Spacer()

            // Right icon buttons vary by configuration
            HStack(spacing: Spacing.m) {
                switch configuration {
                case .initial:
                    PillButton.icon(isSearchActive ? "xmark" : "magnifyingglass", action: {
                        isSearchActive.toggle()
                    })
                case .placeDetails:
                    PillButton.icon("bookmark.fill", isSelected: isBookmarked, action: {
                        isBookmarked.toggle()
                    })
                    PillButton.icon("xmark", action: {
                        onClose?()
                    })
                }
            }
        }
        .padding(.horizontal, Spacing.l)
        .padding(.vertical, Spacing.l)
    }
}

#Preview("Initial Configuration") {
    ActionBar(isSearchActive: .constant(false), configuration: .initial)
}

#Preview("Place Details Configuration") {
    ActionBar(isSearchActive: .constant(false), configuration: .placeDetails, onClose: { print("Close tapped") })
} 
