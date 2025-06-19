import SwiftUI

struct SearchResultsView: View {
    let searchText: String
    let onPlaceTapped: (Place) -> Void
    
    // Temporary placeholder data until we implement actual search
    private let placeholderResults: [Place] = []
    
    var body: some View {
        VStack(spacing: 0) {
            // Use existing SectionHeaderView component
            SectionHeaderView(
                title: "Results for \"\(searchText)\"",
                showViewAllButton: false
            )
            
            // Placeholder for search results - will be implemented in Phase 5
            if placeholderResults.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 48))
                        .foregroundColor(.smoke100)
                    
                    Text("Search functionality coming soon")
                        .font(.body)
                        .foregroundColor(.grey100)
                    
                    Text("This will be implemented in Phase 5")
                        .font(.caption)
                        .foregroundColor(.smoke100)
                }
                .padding(.top, 60)
            } else {
                // This will be implemented when we add actual search in Phase 5
                // ForEach will be added here to display real search results
                EmptyView()
            }
            
            Spacer()
        }
    }
    
    // Helper function to get appropriate icon based on place type
    private func iconForPlaceType(_ types: [String]) -> Image {
        // This function will be updated when we implement actual search in Phase 5
        // For now, return a default icon
        return Image(systemName: "mappin.circle")
    }
    
    // Helper function to get appropriate color based on place type
    private func colorForPlaceType(_ types: [String]) -> Color {
        // This function will be updated when we implement actual search in Phase 5
        // For now, return a default color
        return .green100
    }
}

#Preview {
    SearchResultsView(searchText: "test search", onPlaceTapped: { _ in })
} 