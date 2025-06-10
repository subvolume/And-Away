import SwiftUI

struct SearchBarView: View {
    @Binding var text: String // The text in the search bar, shared with the parent view
    var placeholder: String = "Search..." // Customizable placeholder text
    var verticalPadding: CGFloat = Spacing.m // Overall vertical padding for the component
    @Binding var isEditing: Bool // <--- New binding to report editing state
    @FocusState private var isFocused: Bool // Internal focus state

    var body: some View {
        HStack { // This HStack will now be the styled input field
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField(placeholder, text: $text, onEditingChanged: { editing in // <--- Add onEditingChanged
                self.isEditing = editing // <--- Update the binding
            })
                .textFieldStyle(PlainTextFieldStyle()) // Keep it plain
                .focused($isFocused)
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
        .background(Capsule().fill(Color(.systemGray6)))
        .padding(.horizontal) // Outer horizontal padding for the whole component
        .padding(.vertical, verticalPadding) // Outer vertical padding for the whole component
        .onChange(of: isEditing) { editing in
            isFocused = editing
        }
    }
}

#Preview {
    // Example of how to use SearchBarView in a preview
    // In a real scenario, the @State variable would be in the parent view
    struct PreviewWrapper: View {
        @State private var searchText = "Sample search"
        @State private var searchIsEditing = false // <--- State for the preview
        var body: some View {
            SearchBarView(text: $searchText, isEditing: $searchIsEditing) // <--- Pass the binding
        }
    }
    return PreviewWrapper()
} 