import SwiftUI

struct CustomSheetView: View {
    @State private var searchText = ""
    var showSearchBar: Bool = false // Default to false

    var body: some View {
        VStack {
            if showSearchBar {
                SearchBarView(text: $searchText)
            }
            Text("Sheet Content")
            Spacer()
        }
    }
}

#Preview {
    // Example of how to show the search bar in the preview
    CustomSheetView(showSearchBar: true)
} 