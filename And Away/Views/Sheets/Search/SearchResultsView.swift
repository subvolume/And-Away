import SwiftUI
import GooglePlacesSwift
import CoreLocation
import GoogleMaps

struct SearchResultsView: View {
    let searchText: String
    let userLocation: CLLocationCoordinate2D?
    let mapVisibleRegion: GMSVisibleRegion?
    let mapZoom: Float
    let onPlaceTapped: (String, String?) -> Void
    
    @State private var places: [Place] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    private let placesService = GooglePlacesService()
    
    var body: some View {
        VStack(spacing: 0) {
            // Use existing SectionHeaderView component
            SectionHeaderView(
                title: "Results for \"\(searchText)\"",
                showViewAllButton: false
            )
            
            if isLoading {
                VStack {
                    ProgressView()
                        .padding()
                    Text("Searching places...")
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                Spacer()
            } else if let errorMessage = errorMessage {
                VStack(spacing: 16) {
                    Text("Search Error")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(errorMessage)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 40)
                Spacer()
            } else if places.isEmpty {
                VStack(spacing: 16) {
                    Text("No places found")
                        .foregroundColor(.secondary)
                        .padding()
                    
                    Text("Try searching for something else")
                        .font(.caption)
                        .foregroundColor(.tertiary)
                }
                .padding(.top, 40)
                Spacer()
            } else {
                // Display search results using existing ListItem component
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(places, id: \.placeID) { place in
                            ListItem.searchResult(
                                title: place.displayName ?? "Unknown Place",
                                distance: formatDistance(for: place),
                                location: place.formattedAddress ?? "Unknown Address",
                                icon: Image(systemName: "mappin.circle.fill"),
                                iconColor: .red100,
                                onOpenPlaceDetails: {
                                    if let placeID = place.placeID {
                                        onPlaceTapped(placeID, place.displayName)
                                    }
                                }
                            )
                        }
                    }
                }
            }
        }
        .onAppear {
            searchPlaces()
        }
        .onChange(of: searchText) { _, _ in
            searchPlaces()
        }
    }
    
    private func searchPlaces() {
        guard !searchText.isEmpty else {
            places = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            let result = await placesService.searchPlaces(
                query: searchText, 
                userLocation: userLocation,
                mapVisibleRegion: mapVisibleRegion,
                mapZoom: mapZoom
            )
            
            await MainActor.run {
                isLoading = false
                
                switch result {
                case .success(let searchResults):
                    places = searchResults
                case .failure(let error):
                    places = []
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func formatDistance(for place: Place) -> String {
        // Calculate real distance if user location is available
        guard let userLocation = userLocation else {
            return "Distance unknown"
        }
        
        // Create CLLocation objects for distance calculation
        let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let placeCLLocation = CLLocation(latitude: place.location.latitude, longitude: place.location.longitude)
        
        // Calculate distance in meters
        let distanceInMeters = userCLLocation.distance(from: placeCLLocation)
        
        // Format distance appropriately
        if distanceInMeters < 1000 {
            // Show in meters for distances under 1km
            return "\(Int(distanceInMeters))m"
        } else {
            // Show in kilometers for distances 1km and above
            let distanceInKm = distanceInMeters / 1000
            if distanceInKm < 10 {
                // Show one decimal place for distances under 10km
                return String(format: "%.1fkm", distanceInKm)
            } else {
                // Show whole numbers for distances 10km and above
                return "\(Int(distanceInKm))km"
            }
        }
    }
}

#Preview {
    SearchResultsView(
        searchText: "coffee shops", 
        userLocation: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        mapVisibleRegion: nil,
        mapZoom: 15.0,
        onPlaceTapped: { _, _ in }
    )
} 