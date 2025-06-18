import SwiftUI

struct CategoryIntegrationTest: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var searchText = "coffee"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Category Integration Test")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Search input
            HStack {
                TextField("Search term", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Search") {
                    Task {
                        await viewModel.searchImmediately(query: searchText)
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            
            Text("Testing PlaceCategories.swift Integration")
                .font(.headline)
                .foregroundColor(.secondary)
            
            if viewModel.hasResults {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.searchResults.prefix(5), id: \.placeId) { place in
                            CategoryTestCard(place: place)
                        }
                    }
                    .padding()
                }
            } else if viewModel.isLoading {
                ProgressView("Searching...")
            } else {
                Text("Enter a search term to test category detection")
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .onChange(of: searchText) { _, newValue in
            Task {
                await viewModel.search(query: newValue)
            }
        }
        .onAppear {
            Task {
                await viewModel.search(query: searchText)
            }
        }
    }
}

struct CategoryTestCard: View {
    let place: GooglePlace
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Place info
            HStack {
                VStack(alignment: .leading) {
                    Text(place.name)
                        .font(.headline)
                    
                    if let vicinity = place.vicinity {
                        Text(vicinity)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Category icon and color
                if let category = place.primarySubcategory {
                    VStack(spacing: 4) {
                        Image(systemName: category.icon)
                            .font(.title2)
                            .foregroundColor(category.color)
                            .frame(width: 40, height: 40)
                            .background(category.lightColor)
                            .clipShape(Circle())
                        
                        Text(category.displayName)
                            .font(.caption2)
                            .foregroundColor(category.color)
                    }
                }
            }
            
            // Google place types
            VStack(alignment: .leading, spacing: 4) {
                Text("Google Types:")
                    .font(.caption)
                    .fontWeight(.medium)
                
                Text(place.types.prefix(5).joined(separator: ", "))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            // Category detection results
            VStack(alignment: .leading, spacing: 4) {
                Text("Category Detection:")
                    .font(.caption)
                    .fontWeight(.medium)
                
                if let primaryCategory = place.primarySubcategory {
                    HStack {
                        Text("Primary:")
                        Text(primaryCategory.displayName)
                            .foregroundColor(primaryCategory.color)
                        Text("(\(primaryCategory.mainCategory.displayName))")
                            .foregroundColor(.secondary)
                    }
                    .font(.caption2)
                    
                    let allMatching = place.allMatchingSubcategories
                    if allMatching.count > 1 {
                        Text("Also matches: \(allMatching.dropFirst().map(\.displayName).joined(separator: ", "))")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                } else {
                    Text("❌ No category match found")
                        .font(.caption2)
                        .foregroundColor(.red)
                }
            }
            
            // Test the actual UI components
            Divider()
            
            Text("UI Preview:")
                .font(.caption)
                .fontWeight(.medium)
            
            // Show how it appears in search results
            ListItem.searchResult(
                title: place.name,
                distance: "0km",
                location: place.vicinity ?? "Unknown location",
                icon: iconForPlace(place),
                iconColor: colorForPlace(place),
                onOpenPlaceDetails: {
                    print("Tapped: \(place.name)")
                }
            )
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    
    // Use the same logic as SearchResultsView
    private func iconForPlace(_ place: GooglePlace) -> Image {
        if let category = place.primarySubcategory {
            return Image(systemName: category.icon)
        } else {
            return Image(systemName: "mappin.circle")
        }
    }
    
    private func colorForPlace(_ place: GooglePlace) -> Color {
        // Use the colors defined in PlaceCategories.swift
        if let category = place.primarySubcategory {
            return category.color
        } else {
            return .grey100
        }
    }
}

#Preview {
    CategoryIntegrationTest()
} 