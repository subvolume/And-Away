import SwiftUI

enum SheetState {
    case search
    case placeDetails
}

struct CustomSheetView: View {
    @State private var searchText = ""
    @State private var isSearchActive = false // 1. State to track search bar focus
    @State private var sheetState: SheetState = .search // 2. State to manage sheet content
    var showSearchBar: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            if showSearchBar && sheetState == .search {
                // 2. Pass the isSearchActive state to the SearchBarView - stays at top
                SearchBarView(text: $searchText, isEditing: $isSearchActive)
            }
            
            ScrollView {
                // 3. Show different content based on sheet state
                switch sheetState {
                case .search:
                    if isSearchActive {
                        SearchStateView(searchText: $searchText, onPlaceTapped: {
                            sheetState = .placeDetails
                        })
                    } else {
                        ArtworkExampleView() // Show this when search is not active (initial state)
                    }
                case .placeDetails:
                    PlaceDetailsView(onBackTapped: {
                        sheetState = .search
                    })
                }
                // Text("Sheet Content") // I'm commenting this out, assuming A/B replaces it. Let me know if it should stay.
            }
        }
    }
}

#Preview {
    CustomSheetView(showSearchBar: true)
} 
