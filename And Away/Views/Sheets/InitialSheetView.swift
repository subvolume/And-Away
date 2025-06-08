import SwiftUI

enum SheetState {
    case search
}

struct InitialSheetView: View {
    @State private var searchText = ""
    @State private var isSearchActive = false // 1. State to track search bar focus
    @State private var sheetState: SheetState = .search // 2. State to manage sheet content
    @State private var selectedPlace: PlaceSearchResult? = nil // Track selected place for sheet presentation
    @State private var showPlaceDetails = false // State to control PlaceDetailsView sheet
    var showSearchBar: Bool = true
    
    @EnvironmentObject var sheetController: SheetController

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
                    if isSearchActive || !searchText.isEmpty {
                        SearchStateView(searchText: $searchText, onPlaceTapped: { place in
                            selectedPlace = place
                            showPlaceDetails = true
                            // Dismiss keyboard when showing place details
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            // Present the details sheet level
                            sheetController.presentSheet(.details)
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
                // Restore search focus to bring back keyboard
                isSearchActive = true
                // Dismiss the details sheet level
                sheetController.dismissSheet(.details)
            })
            .managedSheetDetents(controller: sheetController, level: .details)
        }
    }
}

#Preview {
    InitialSheetView(showSearchBar: true)
        .environmentObject(SheetController())
} 