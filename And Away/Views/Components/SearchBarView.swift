import SwiftUI

struct SearchBarView: View {
    @Binding var text: String // The text in the search bar, shared with the parent view
    var placeholder: String = "Search..." // Customizable placeholder text

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle()) // Basic styling
                .padding(.vertical, 8) // Adjust vertical padding for size
                .padding(.horizontal, 10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            // Optional: Add a clear button if text is not empty
            if !text.isEmpty {
                Button(action: {
                    self.text = "" // Clear the text
                }) {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 6)
            }
        }
        .padding(.horizontal) // Add some padding around the HStack
        .frame(height: 44) // Example height, you can customize this
    }
}

#Preview {
    // Example of how to use SearchBarView in a preview
    // In a real scenario, the @State variable would be in the parent view
    struct PreviewWrapper: View {
        @State private var searchText = "Sample search"
        var body: some View {
            SearchBarView(text: $searchText)
        }
    }
    return PreviewWrapper()
} 