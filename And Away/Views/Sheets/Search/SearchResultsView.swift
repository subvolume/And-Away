import SwiftUI
import CoreLocation

struct SearchResultsView: View {
    let searchText: String
    let onPlaceTapped: (PlaceSearchResult) -> Void
    
    @EnvironmentObject private var searchViewModel: SearchViewModel
    @EnvironmentObject private var locationService: LocationService
    
    var body: some View {
        VStack(spacing: 0) {
            // Use existing SectionHeaderView component
            SectionHeaderView(
                title: "Results for \"\(searchText)\"",
                showViewAllButton: false
            )
            
            // Show loading indicator
            if searchViewModel.isLoading {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Searching...")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            
            // Show error if any
            if let errorMessage = searchViewModel.errorMessage {
                Text(errorMessage)
                    .font(.body)
                    .foregroundColor(.red)
                    .padding()
            }
            
            // Show search results from Google
            ForEach(searchViewModel.searchResults, id: \.placeId) { place in
                ListItem.searchResult(
                    title: place.name,
                    distance: calculateDistance(to: place),
                    location: place.simpleLocationName,
                    icon: PlaceTypeHelpers.iconForPlaceType(place.types),
                    iconColor: PlaceTypeHelpers.colorForPlaceType(place.types),
                    onOpenPlaceDetails: {
                        onPlaceTapped(place)
                    }
                )
            }
            
            Spacer()
        }
        .onAppear {
            // Set user location for better search results
            searchViewModel.userLocation = locationService.currentLocation
            
            // Trigger search when view appears
            searchViewModel.searchText = searchText
            searchViewModel.searchPlaces()
        }
        .onChange(of: searchText) { newValue in
            // Update search when text changes
            searchViewModel.searchText = newValue
            searchViewModel.searchPlaces()
        }
        .onChange(of: locationService.currentLocation) { newLocation in
            // Update search results when location changes
            searchViewModel.userLocation = newLocation
            if !searchViewModel.searchResults.isEmpty {
                // Refresh search with new location bias
                searchViewModel.searchPlaces()
            }
        }
    }
    
    

    
    // Helper function to calculate real distance
    private func calculateDistance(to place: PlaceSearchResult) -> String {
        guard let userLocation = locationService.currentLocation else {
            return "N/A"
        }
        
        let placeLocation = CLLocation(
            latitude: place.geometry.location.lat,
            longitude: place.geometry.location.lng
        )
        
        let distance = userLocation.distance(from: placeLocation) // in meters
        
        // Format distance appropriately
        if distance < 1000 {
            return "\(Int(distance))m"
        } else {
            let kilometers = distance / 1000
            if kilometers < 10 {
                return String(format: "%.1fkm", kilometers)
            } else {
                return "\(Int(kilometers))km"
            }
        }
    }
}

#Preview {
    SearchResultsView(searchText: "test search", onPlaceTapped: { _ in })
        .environmentObject(LocationService.shared)
        .environmentObject(SearchViewModel())
} 