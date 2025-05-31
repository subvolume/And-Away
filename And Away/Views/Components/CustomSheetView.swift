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
            // Fixed headers that stay at the top
            if showSearchBar && sheetState == .search {
                SearchBarView(text: $searchText, isEditing: $isSearchActive)
            }
            
            if sheetState == .placeDetails {
                SheetHeader(title: "Place Details", onClose: {
                    sheetState = .search
                })
            }
            
            // Scrollable content
            ScrollView {
                switch sheetState {
                case .search:
                    if isSearchActive {
                        SearchStateView(searchText: $searchText, onPlaceTapped: {
                            sheetState = .placeDetails
                        })
                    } else {
                        ArtworkExampleView()
                    }
                case .placeDetails:
                    // Only the scrollable content of place details, not the header
                    VStack(spacing: Spacing.xs) {
                        PlaceDetailsActions()
                        ImageCarouselView()
                    }
                }
            }
        }
    }
}

#Preview {
    CustomSheetView(showSearchBar: true)
} 
