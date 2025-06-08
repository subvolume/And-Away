import SwiftUI

struct SearchResultsView: View {
    let searchText: String
    let onPlaceTapped: (PlaceSearchResult) -> Void
    
    @StateObject private var searchViewModel = SearchViewModel()
    
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
                    distance: "\(Int.random(in: 1...20))km", // Mock distance for now
                    location: place.vicinity ?? "Unknown location",
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
            // Trigger search when view appears
            searchViewModel.searchText = searchText
            searchViewModel.searchPlaces()
        }
        .onChange(of: searchText) { newValue in
            // Update search when text changes
            searchViewModel.searchText = newValue
            searchViewModel.searchPlaces()
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
    SearchResultsView(searchText: "test search", onPlaceTapped: { _ in })
} 