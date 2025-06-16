import SwiftUI

struct ActionBar: View {
    @Binding var isSearchActive: Bool
    
    var body: some View {
        HStack {
            // Left button with icon and text
            PillButton.textIcon(
                text: "Save",
                icon: "heart",
                action: {}
            )

            Spacer()

            // Right icon buttons
            PillButton.icon("square.and.arrow.up", action: {})
            PillButton.icon("magnifyingglass", action: {
                isSearchActive = true
            })
        }
        .padding(.horizontal, Spacing.m)
        .padding(.vertical, Spacing.m)
        //.background(.ultraThinMaterial)
    }
}

#Preview {
    ActionBar(isSearchActive: .constant(false))
} 
