import SwiftUI

struct SearchResultsView: View {
    let searchText: String
    let onPlaceTapped: (GooglePlace) -> Void
    
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // Section header
            SectionHeaderView(
                title: "Results for \"\(searchText)\"",
                showViewAllButton: false
            )
            
            // Main content based on search state
            Group {
                switch viewModel.searchState {
                case .empty:
                    EmptyView()
                    
                case .loading:
                    LoadingView()
                    
                case .error(let message):
                    ErrorView(message: message) {
                        Task {
                            await viewModel.searchImmediately(query: searchText)
                        }
                    }
                    
                case .noResults:
                    NoResultsView(query: searchText)
                    
                case .results(let places):
                    ResultsListView(places: places, onPlaceTapped: onPlaceTapped)
                }
            }
            
            Spacer()
        }
        .onChange(of: searchText) { _, newValue in
            Task {
                await viewModel.search(query: newValue)
            }
        }
        .onAppear {
            if !searchText.isEmpty {
                Task {
                    await viewModel.search(query: searchText)
                }
            }
        }
        .onDisappear {
            viewModel.cancelCurrentSearch()
        }
    }
}

// MARK: - Loading View
private struct LoadingView: View {
    var body: some View {
        ProgressView("Searching...")
            .frame(maxWidth: .infinity)
            .padding()
    }
}

// MARK: - Error View  
private struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 32))
                .foregroundColor(.orange)
            
            Text(message)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Try Again") {
                onRetry()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

// MARK: - No Results View
private struct NoResultsView: View {
    let query: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 32))
                .foregroundColor(.secondary)
            
            Text("No results found")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Try adjusting your search for '\(query)'")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

// MARK: - Results List View
private struct ResultsListView: View {
    let places: [GooglePlace]
    let onPlaceTapped: (GooglePlace) -> Void
    
    var body: some View {
        ForEach(places) { place in
            ListItem.searchResult(
                title: place.name,
                distance: "0km", // TODO: Calculate with real location later
                location: place.vicinity ?? "Unknown location",
                icon: iconForPlaceType(place.types),
                iconColor: colorForPlaceType(place.types),
                onOpenPlaceDetails: {
                    onPlaceTapped(place)
                }
            )
        }
    }
    
    // MARK: - Helper Methods
    
    private func iconForPlaceType(_ types: [String]) -> Image {
        // Use your existing icon logic or integrate with PlaceCategories
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
    
    private func colorForPlaceType(_ types: [String]) -> Color {
        // Use your existing color logic or integrate with PlaceCategories
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
    SearchResultsView(
        searchText: "coffee",
        onPlaceTapped: { place in
            print("Tapped: \(place.name)")
        }
    )
} 