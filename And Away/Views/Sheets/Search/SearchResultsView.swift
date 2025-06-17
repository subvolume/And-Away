import SwiftUI

struct SearchResultsView: View {
    let searchText: String
    let onPlaceTapped: (Place) -> Void
    
    // State for async search results using MockPlacesService
    @State private var searchResults: [Place] = []
    @State private var isLoading: Bool = false
    @State private var searchTask: Task<Void, Never>?
    
    // Mock service instance
    private let placesService = MockPlacesService()
    
    var body: some View {
        VStack(spacing: 0) {
            // Use existing SectionHeaderView component
            SectionHeaderView(
                title: searchText.isEmpty ? "Nearby Places" : "Results for \"\(searchText)\"",
                showViewAllButton: false
            )
            
            if isLoading {
                // Simple loading indicator
                HStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                    Spacer()
                }
            } else {
                // Use the searchResult template from ListItem with our MockPlacesService results
                ForEach(searchResults, id: \.id) { place in
                    ListItem.searchResult(
                        title: place.name,
                        distance: place.formattedDistance ?? "Unknown distance",
                        location: place.address,
                        icon: Image(systemName: place.category.icon),
                        iconColor: colorForCategory(place.category),
                        onOpenPlaceDetails: {
                            onPlaceTapped(place)
                        }
                    )
                }
            }
            
            Spacer()
        }
        .onAppear {
            performSearch()
        }
        .onChange(of: searchText) { oldValue, newValue in
            performSearch()
        }
        .onDisappear {
            // Cancel any ongoing search task
            searchTask?.cancel()
        }
    }
    
    // MARK: - Search Methods
    
    /// Perform search using MockPlacesService
    private func performSearch() {
        // Cancel any existing search task
        searchTask?.cancel()
        
        // Start new search task
        searchTask = Task {
            await MainActor.run {
                isLoading = true
            }
            
            do {
                let results: [Place]
                
                if searchText.isEmpty {
                    // Show nearby places when no search text
                    let organizedResults = try await placesService.searchPlaces(
                        query: "",
                        location: nil,
                        radius: 2000.0
                    )
                    results = organizedResults.allResults.map { $0.place }
                } else {
                    // Perform text search
                    let organizedResults = try await placesService.searchPlaces(
                        query: searchText,
                        location: nil,
                        radius: nil
                    )
                    results = organizedResults.allResults.map { $0.place }
                }
                
                await MainActor.run {
                    if !Task.isCancelled {
                        self.searchResults = results
                        self.isLoading = false
                    }
                }
                
            } catch {
                await MainActor.run {
                    if !Task.isCancelled {
                        // On error, fallback to empty results
                        self.searchResults = []
                        self.isLoading = false
                    }
                }
            }
        }
    }
    
    // Helper function to get appropriate color based on our new category system
    private func colorForCategory(_ category: PlaceCategory) -> Color {
        switch category.id {
        case "restaurant":
            return .orange100
        case "coffee_shop":
            return .teal100
        case "park":
            return .green100
        case "museum":
            return .purple100
        case "shopping":
            return .azure100
        case "hotel":
            return .indigo // Using indigo as fallback
        default:
            return .gray // Generic fallback
        }
    }
}

#Preview {
    SearchResultsView(searchText: "test search", onPlaceTapped: { _ in })
} 