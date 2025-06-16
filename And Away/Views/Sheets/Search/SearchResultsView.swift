import SwiftUI

struct SearchResultsView: View {
    let searchText: String
    let onPlaceTapped: (Place) -> Void
    
    // Using our new foundation mock data
    private var searchResults: [Place] {
        if searchText.isEmpty {
            return MockPlacesData.samplePlaces
        } else {
            return MockPlacesData.searchPlaces(query: searchText)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Use existing SectionHeaderView component
            SectionHeaderView(
                title: "Results for \"\(searchText)\"",
                showViewAllButton: false
            )
            
            // Use the searchResult template from ListItem with our new mock data
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
            
            Spacer()
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