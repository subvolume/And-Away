import SwiftUI
import CoreLocation

struct InitialSheetView: View {
    @State private var searchText = ""
    @State private var isSearchActive = false
    @State private var showPlaceDetails = false
    @State private var selectedPlaceId: String? = nil
    @State private var selectedPlaceName: String? = nil
    
    let userLocation: CLLocationCoordinate2D?
    
    @EnvironmentObject var sheetController: SheetController
    
    var body: some View {
        Group {
            if isSearchActive {
                NavigationStack {
                    ZStack(alignment: .bottom) {
                        ScrollView {
                            SearchStateView(
                                searchText: $searchText, 
                                userLocation: userLocation,
                                onPlaceTapped: { placeId, placeName in
                                    selectedPlaceId = placeId
                                    selectedPlaceName = placeName
                                    isSearchActive = false  // Dismiss search when viewing details
                                    showPlaceDetails = true
                                    // Present the details sheet level using SheetController
                                    sheetController.presentSheet(.details)
                                }
                            )
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
                placeName: selectedPlaceName,
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
    InitialSheetView(
        userLocation: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    )
    .environmentObject(SheetController())
} 
