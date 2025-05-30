import SwiftUI

struct CustomSheetView: View {
    @State private var searchText = ""
    @State private var isSearchActive = false // 1. State to track search bar focus
    var showSearchBar: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            if showSearchBar {
                // 2. Pass the isSearchActive state to the SearchBarView - stays at top
                SearchBarView(text: $searchText, isEditing: $isSearchActive)
            }
            
            ScrollView {
                // 3. Conditionally display ContentAView or ContentBView - scrolls underneath
                if isSearchActive {
                    ContentBView() // Show B when search is active
                } else {
                    ContentAView() // Show A when search is not active (initial state)
                }
                // Text("Sheet Content") // I'm commenting this out, assuming A/B replaces it. Let me know if it should stay.
            }
        }
    }
}

#Preview {
    CustomSheetView(showSearchBar: true)
} 
