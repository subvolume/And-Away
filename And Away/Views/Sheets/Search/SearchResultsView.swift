import SwiftUI

struct SearchResultsView: View {
    let searchText: String
    let onPlaceTapped: (PlaceSearchResult) -> Void
    
    @State private var searchResults: [GooglePlace] = []
    @State private var isLoading = false
    @State private var searchTimer: Timer?
    
    // Add your API key here
    private let apiKey = "AIzaSyDuKI9Sn6gMj6yN8WUz4_TgeO1gjEo479E"
    
    var body: some View {
        VStack(spacing: 0) {
            // Use existing SectionHeaderView component
            SectionHeaderView(
                title: "Results for \"\(searchText)\"",
                showViewAllButton: false
            )
            
            if isLoading {
                ProgressView("Searching...")
                    .frame(maxWidth: .infinity)
                    .padding()
            } else if searchResults.isEmpty && !searchText.isEmpty {
                Text("No results found")
                    .foregroundColor(.secondary)
                    .padding()
            } else if !searchResults.isEmpty {
                // Use the searchResult template from ListItem with real data
                ForEach(searchResults) { place in
                    ListItem.searchResult(
                        title: place.name,
                        distance: "0km", // Will calculate with real location later
                        location: place.vicinity ?? "Unknown location",
                        icon: iconForPlaceType(place.types),
                        iconColor: colorForPlaceType(place.types),
                        onOpenPlaceDetails: {
                            // Convert GooglePlace to PlaceSearchResult for callback
                            let placeResult = PlaceSearchResult(
                                placeId: place.placeId,
                                name: place.name,
                                vicinity: place.vicinity,
                                types: place.types,
                                geometry: PlaceGeometry(location: place.location ?? PlaceLocation(lat: 0, lng: 0)),
                                photos: place.photos
                            )
                            onPlaceTapped(placeResult)
                        }
                    )
                }
            }
            
            Spacer()
        }
        .onChange(of: searchText) {
            performSearch()
        }
        .onAppear {
            if !searchText.isEmpty {
                performSearch()
            }
        }
    }
    
    private func performSearch() {
        // Cancel previous search
        searchTimer?.invalidate()
        
        // Clear results if text is empty
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            searchResults = []
            isLoading = false
            return
        }
        
        // Show loading immediately for better UX
        isLoading = true
        
        // Debounce with 0.5 second delay
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            Task {
                await executeSearch()
            }
        }
    }
    
    @MainActor
    private func executeSearch() async {
        let service = GooglePlacesService(apiKey: apiKey)
        
        do {
            // Use autocomplete for fast suggestions
            let results = try await service.autocomplete(query: searchText)
            searchResults = results
            isLoading = false
        } catch {
            print("Search error: \(error)")
            searchResults = []
            isLoading = false
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
}

#Preview {
    SearchResultsView(searchText: "coffee", onPlaceTapped: { _ in })
} 