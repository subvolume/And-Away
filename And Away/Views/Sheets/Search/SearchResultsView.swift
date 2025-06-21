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
    @State private var matchedCategories: [Subcategory] = []
    @State private var isSearchingCategory = false
    @State private var searchingCategoryName: String?
    
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
                    Text(isSearchingCategory ? "Searching \(searchingCategoryName ?? "places") near you..." : "Searching places...")
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
            } else if places.isEmpty && matchedCategories.isEmpty {
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
                        // Show category suggestions at the top (up to 3)
                        if !matchedCategories.isEmpty && !isSearchingCategory {
                            ForEach(matchedCategories.prefix(3), id: \.self) { category in
                                ListItem.iconOnly(
                                    title: "\(category.rawValue) near me",
                                    icon: category.icon,
                                    onTap: {
                                        searchNearbyCategory(category)
                                    }
                                )
                            }
                        }
                        
                        ForEach(places, id: \.placeID) { place in
                            let _ = print("Place: \(place.displayName ?? "Unknown") - Types: \(place.types.map { $0.rawValue })")
                            
                            // Get category styling based on place types
                            let googleTypes = place.types.map { $0.rawValue }
                            let categoryIcon = CategoryStyle.categoryIcon(for: googleTypes)
                            let categoryColor = CategoryStyle.categoryColor(for: googleTypes)
                            
                            ListItem.searchResult(
                                title: place.displayName ?? "Unknown Place",
                                distance: formatDistance(for: place),
                                location: formatLocationWithType(for: place),
                                icon: categoryIcon,
                                iconColor: categoryColor,
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
            checkForCategoryMatches()
            searchPlaces()
        }
        .onChange(of: searchText) { _, _ in
            checkForCategoryMatches()
            searchPlaces()
        }
    }
    
    private func checkForCategoryMatches() {
        // Find all matching categories
        var matches: [Subcategory] = []
        
        // Check each subcategory for matches
        for subcategory in Subcategory.allCases {
            if CategoryStyle.matchesSearch(searchText: searchText, category: subcategory) {
                matches.append(subcategory)
                // Stop after finding 3 matches
                if matches.count >= 3 {
                    break
                }
            }
        }
        
        matchedCategories = matches
    }
    
    private func searchNearbyCategory(_ category: Subcategory) {
        guard let userLocation = userLocation else {
            errorMessage = "Location not available. Please enable location services."
            return
        }
        
        isLoading = true
        isSearchingCategory = true
        searchingCategoryName = category.rawValue
        errorMessage = nil
        
        Task {
            // Use text search with category name instead of nearby search
            let searchQuery = "\(category.rawValue) near me"
            let result = await placesService.searchPlaces(
                query: searchQuery,
                userLocation: userLocation,
                mapVisibleRegion: mapVisibleRegion,
                mapZoom: mapZoom
            )
            
            await MainActor.run {
                isLoading = false
                isSearchingCategory = false
                searchingCategoryName = nil
                
                switch result {
                case .success(let searchResults):
                    places = searchResults
                    matchedCategories = [] // Hide the category suggestions after search
                case .failure(let error):
                    places = []
                    errorMessage = error.localizedDescription
                }
            }
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
    
    private func formatLocationWithType(for place: Place) -> String {
        // Get category name from CategoryStyle
        let googleTypes = place.types.map { $0.rawValue }
        let categoryName = CategoryStyle.formattedCategoryName(for: googleTypes)
        
        let address = place.formattedAddress ?? "Unknown Address"
        
        // Combine category and address
        return "\(categoryName) • \(address)"
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