import SwiftUI

struct SearchBarView: View {
    @Binding var text: String // The text in the search bar, shared with the parent view
    var placeholder: String = "Search..." // Customizable placeholder text
    var verticalPadding: CGFloat = Spacing.m // Overall vertical padding for the component

    var body: some View {
        HStack { // This HStack will now be the styled input field
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle()) // Keep it plain
                // Removed specific padding, background, and cornerRadius from TextField

            if !text.isEmpty {
                Button(action: {
                    self.text = "" // Clear the text
                }) {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(.gray)
                }
                // Removed .padding(.trailing, 6) from button, will be handled by HStack's padding
            }
        }
        .padding(.vertical, 8) // Inner vertical padding for the HStack (was on TextField)
        .padding(.horizontal, 10) // Inner horizontal padding for the HStack (was on TextField)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal) // Outer horizontal padding for the whole component
        .padding(.vertical, verticalPadding) // Outer vertical padding for the whole component
    }
}

#Preview {
    // Example of how to use SearchBarView in a preview
    // In a real scenario, the @State variable would be in the parent view
    struct PreviewWrapper: View {
        @State private var searchText = "Sample search"
        var body: some View {
            SearchBarView(text: $searchText) // Default padding
        }
    }
    return PreviewWrapper()
} 