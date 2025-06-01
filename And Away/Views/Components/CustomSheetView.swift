import SwiftUI

enum SheetState {
    case search
}

struct CustomSheetView: View {
    @State private var searchText = ""
    @State private var isSearchActive = false // 1. State to track search bar focus
    @State private var sheetState: SheetState = .search // 2. State to manage sheet content
    @State private var selectedPlace: PlaceSearchResult? = nil // Track selected place for sheet presentation
    @State private var showPlaceDetails = false // State to control PlaceDetailsView sheet
    var showSearchBar: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            // Fixed headers that stay at the top
            if showSearchBar && sheetState == .search {
                SearchBarView(text: $searchText, isEditing: $isSearchActive)
            }
            
            // Scrollable content
            ScrollView {
                switch sheetState {
                case .search:
                    if isSearchActive {
                        SearchStateView(searchText: $searchText, onPlaceTapped: { place in
                            selectedPlace = place
                            showPlaceDetails = true
                        })
                    } else {
                        ArtworkExampleView()
                    }
                }
            }
        }
        .sheet(isPresented: $showPlaceDetails) {
            PlaceDetailsView(onBackTapped: {
                showPlaceDetails = false
            })
        }
    }
}

#Preview {
    CustomSheetView(showSearchBar: true)
} 