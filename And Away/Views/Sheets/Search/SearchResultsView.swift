import SwiftUI

struct SearchResultsView: View {
    let searchText: String
    let onPlaceTapped: (Place) -> Void
    
    @StateObject private var placesService = GooglePlacesService()
    @StateObject private var locationManager = LocationManager.shared
    @State private var searchResults: [Place] = []
    @State private var hasSearched = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Use existing SectionHeaderView component
            SectionHeaderView(
                title: "Results for \"\(searchText)\"",
                showViewAllButton: false
            )
            
            // Search results
            if placesService.isLoading {
                VStack(spacing: 16) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                    Text("Searching...")
                        .font(.body)
                        .foregroundColor(.grey100)
                }
                .padding(.top, 60)
            } else if searchResults.isEmpty && hasSearched {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.magnifyingglass")
                        .font(.system(size: 48))
                        .foregroundColor(.smoke100)
                    
                    Text("No places found")
                        .font(.body)
                        .foregroundColor(.grey100)
                    
                    Text("Try a different search term")
                        .font(.caption)
                        .foregroundColor(.smoke100)
                }
                .padding(.top, 60)
            } else if !searchResults.isEmpty {
                LazyVStack(spacing: 0) {
                    ForEach(searchResults) { place in
                        ListItem.searchResult(
                            title: place.name,
                            distance: "N/A", // We'll add distance calculation later
                            location: place.address.shortAddress,
                            icon: iconForPlaceType([place.category.primaryType]),
                            iconColor: colorForPlaceType([place.category.primaryType]),
                            onOpenPlaceDetails: {
                                onPlaceTapped(place)
                            }
                        )
                    }
                }
            }
            
            Spacer()
        }
        .onAppear {
            performSearch()
        }
        .onChange(of: searchText) { newValue in
            if !newValue.isEmpty {
                performSearch()
            }
        }
    }
    
    private func performSearch() {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            searchResults = []
            hasSearched = false
            return
        }
        
        Task {
            do {
                hasSearched = true
                let results = try await placesService.search(
                    text: searchText,
                    userLocation: locationManager.currentLocation?.coordinate
                )
                await MainActor.run {
                    searchResults = results
                }
            } catch {
                await MainActor.run {
                    searchResults = []
                    print("Search error: \(error)")
                }
            }
        }
    }
    
    // Helper function to get appropriate icon based on place type
    private func iconForPlaceType(_ types: [String]) -> Image {
        // Simple mapping for common place types
        for type in types {
            switch type.lowercased() {
            case let t where t.contains("restaurant") || t.contains("food"):
                return Image(systemName: "fork.knife")
            case let t where t.contains("cafe") || t.contains("coffee"):
                return Image(systemName: "cup.and.saucer")
            case let t where t.contains("gas") || t.contains("station"):
                return Image(systemName: "fuelpump")
            case let t where t.contains("store") || t.contains("shop"):
                return Image(systemName: "storefront")
            case let t where t.contains("hotel") || t.contains("lodging"):
                return Image(systemName: "bed.double")
            case let t where t.contains("hospital") || t.contains("pharmacy"):
                return Image(systemName: "cross")
            default:
                continue
            }
        }
        return Image(systemName: "mappin.circle")
    }
    
    // Helper function to get appropriate color based on place type
    private func colorForPlaceType(_ types: [String]) -> Color {
        // Simple mapping for common place types
        for type in types {
            switch type.lowercased() {
            case let t where t.contains("restaurant") || t.contains("food"):
                return .orange
            case let t where t.contains("cafe") || t.contains("coffee"):
                return .brown
            case let t where t.contains("gas") || t.contains("station"):
                return .blue
            case let t where t.contains("store") || t.contains("shop"):
                return .green
            case let t where t.contains("hotel") || t.contains("lodging"):
                return .purple
            case let t where t.contains("hospital") || t.contains("pharmacy"):
                return .red
            default:
                continue
            }
        }
        return .gray
    }
}

#Preview {
    SearchResultsView(searchText: "test search", onPlaceTapped: { _ in })
} 