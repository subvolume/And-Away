import SwiftUI

struct ActionBar: View {
    @Binding var isSearchActive: Bool
    
    var body: some View {
        HStack {
            // Left button with icon and text
            PillButton.text("Plan today", action: {})

            Spacer()

            // Right icon buttons
            HStack(spacing: Spacing.m) {
                PillButton.icon("square.and.arrow.up", action: {})
                PillButton.icon("magnifyingglass", action: {
                    isSearchActive = true
                })
            }
        }
        .padding(.horizontal, Spacing.l)
        .padding(.vertical, Spacing.l)
    }
}

#Preview {
    ActionBar(isSearchActive: .constant(false))
} 
