import SwiftUI
import CoreLocation

struct SearchResultsView: View {
    let searchText: String
    let onPlaceTapped: (PlaceSearchResult) -> Void
    
    @StateObject private var searchViewModel = SearchViewModel()
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
                    icon: iconForPlaceType(place.types),
                    iconColor: colorForPlaceType(place.types),
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
    
    // Helper function to get appropriate icon based on place type
    private func iconForPlaceType(_ types: [String]) -> Image {
        if types.contains("restaurant") || types.contains("food") {
            return Image(systemName: "fork.knife")
        } else if types.contains("cafe") {
            return Image(systemName: "cup.and.saucer")
        } else if types.contains("tourist_attraction") {
            return Image(systemName: "camera")
        } else if types.contains("museum") {
            return Image(systemName: "building.columns")
        } else {
            return Image(systemName: "mappin.circle")
        }
    }
    
    // Helper function to get appropriate color based on place type
    private func colorForPlaceType(_ types: [String]) -> Color {
        if types.contains("restaurant") || types.contains("food") {
            return .orange100
        } else if types.contains("cafe") {
            return .teal100
        } else if types.contains("tourist_attraction") {
            return .azure100
        } else if types.contains("museum") {
            return .purple100
        } else {
            return .green100
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
} 