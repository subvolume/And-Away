import SwiftUI

struct InitialSheetView: View {
    @State private var searchText = ""
    @State private var isSearchActive = false
    @State private var showPlaceDetails = false
    @State private var selectedPlace: PlaceSearchResult? = nil
    
    @EnvironmentObject var sheetController: SheetController
    
    var body: some View {
        VStack {
            SearchBarView(text: $searchText, isEditing: $isSearchActive)
            ScrollView {
                if isSearchActive || !searchText.isEmpty {
                    SearchStateView(searchText: $searchText, onPlaceTapped: { place in
                        selectedPlace = place
                        isSearchActive = false  // Dismiss input when viewing details
                        showPlaceDetails = true
                        // Present the details sheet level using SheetController
                        sheetController.presentSheet(.details)
                    })
                } else {
                    DummyView()
                }
            }
        }
        .onChange(of: isSearchActive) { oldValue, newValue in
            sheetController.setKeyboardVisible(newValue, for: .list)
        }
        .sheet(isPresented: $showPlaceDetails) {
            PlaceDetailsView(
                placeId: selectedPlace?.placeId ?? "ChIJL-ROikVu5kcRzWBvNS3lnM0",
                onBackTapped: {
                    showPlaceDetails = false
                    isSearchActive = true  // Restore search focus when returning
                    // Dismiss the details sheet level using SheetController
                    sheetController.dismissSheet(.details)
                }
            )
            .managedSheetDetents(controller: sheetController, level: .details)
        }
    }
}

#Preview {
    InitialSheetView()
        .environmentObject(SheetController())
} 
