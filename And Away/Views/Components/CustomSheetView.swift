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
                // 3. Show search content when active, artwork examples when inactive
                if isSearchActive {
                    SearchStateView(searchText: $searchText) // Show search states when active
                } else {
                    ArtworkExampleView() // Show this when search is not active (initial state)
                }
                // Text("Sheet Content") // I'm commenting this out, assuming A/B replaces it. Let me know if it should stay.
            }
        }
    }
}

#Preview {
    CustomSheetView(showSearchBar: true)
} 
