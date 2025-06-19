import SwiftUI

struct InitialSheetView: View {
    @State private var searchText = ""
    @State private var isSearchActive = false
    @State private var showPlaceDetails = false
    @State private var selectedPlaceId: String? = nil
    
    @EnvironmentObject var sheetController: SheetController
    
    var body: some View {
        Group {
            if isSearchActive {
                NavigationStack {
                    ZStack(alignment: .bottom) {
                        ScrollView {
                            SearchStateView(searchText: $searchText, onPlaceTapped: { placeId in
                                selectedPlaceId = placeId
                                isSearchActive = false  // Dismiss search when viewing details
                                showPlaceDetails = true
                                // Present the details sheet level using SheetController
                                sheetController.presentSheet(.details)
                            })
                        }
                        ActionBar(isSearchActive: $isSearchActive)
                            .frame(maxWidth: .infinity)
                    }
                    .ignoresSafeArea(.container, edges: .bottom)
                }
                .searchable(text: $searchText, isPresented: $isSearchActive)
            } else {
                ZStack(alignment: .bottom) {
                    VStack {
                        ScrollView {
                            DummyView()
                        }
                    }
                    ActionBar(isSearchActive: $isSearchActive)
                        .frame(maxWidth: .infinity)
                }
                .ignoresSafeArea(.container, edges: .bottom)
            }
        }
        .sheet(isPresented: $showPlaceDetails) {
            PlaceDetailsView(
                placeId: selectedPlaceId ?? "sample-place-id",
                onBackTapped: {
                    showPlaceDetails = false
                    // Dismiss the details sheet level using SheetController
                    sheetController.dismissSheet(.details)
                }
            )
            .managedSheetDetents(controller: sheetController, level: .details)
        }
        .onChange(of: isSearchActive) { oldValue, newValue in
            sheetController.setKeyboardVisible(newValue, for: .list)
        }
    }
}

#Preview {
    InitialSheetView()
        .environmentObject(SheetController())
} 
