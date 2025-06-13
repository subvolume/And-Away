import SwiftUI

struct ActionBar: View {
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
            PillButton.icon("location", action: {})
        }
        .padding(.horizontal, Spacing.m)
        .padding(.vertical, Spacing.s)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    ActionBar()
} 
