import SwiftUI
import GooglePlacesSwift

struct SearchResultsView: View {
    let searchText: String
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
                                distance: formatDistance(place: place),
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
            let result = await placesService.searchPlaces(query: searchText)
            
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
    
    private func formatDistance(place: Place) -> String {
        // For now, return a placeholder distance
        // This can be enhanced later with actual distance calculation
        return "~1km"
    }
}

#Preview {
    SearchResultsView(searchText: "coffee shops", onPlaceTapped: { _, _ in })
} 