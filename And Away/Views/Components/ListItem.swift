import SwiftUI

struct ListItem: View {
    var body: some View {
        HStack {
            Rectangle() // Placeholder for the icon
                .frame(width: 40, height: 40) // Adjust size as needed
                .foregroundColor(.black) // Placeholder color

            VStack(alignment: .leading) {
                Text("Text1")
                    .font(.headline) // Makes text bold and slightly larger

                HStack(spacing: 4) { // Spacing between Text2, bullet, and Text3
                    Text("Text2")
                    Text("•")
                    Text("Text3")
                }
                .font(.subheadline) // Makes text slightly smaller
                .foregroundColor(.gray) // Sets the text color to gray
            }
        }
        .padding(.vertical) // Adds default top/bottom padding
        .padding(.horizontal, Spacing.m) // Adds horizontal padding using Spacing.m
        .frame(maxWidth: .infinity, alignment: .leading) // Makes the HStack take full available width, content aligned left
    }
}

#Preview {
    ListItem()
} 