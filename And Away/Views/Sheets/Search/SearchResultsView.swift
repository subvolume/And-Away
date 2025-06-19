import SwiftUI

struct SearchResultsView: View {
    let searchText: String
    let onPlaceTapped: (String) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Use existing SectionHeaderView component
            SectionHeaderView(
                title: "Results for \"\(searchText)\"",
                showViewAllButton: false
            )
            
            // Placeholder content - will be replaced when data models are added
            VStack(spacing: 16) {
                Text("Search results will appear here")
                    .foregroundColor(.secondary)
                    .padding()
                
                Text("Data models will be set up in the next step")
                    .font(.caption)
                    .foregroundColor(.tertiary)
            }
            .padding(.top, 40)
            
            Spacer()
        }
    }
}

#Preview {
    SearchResultsView(searchText: "test search", onPlaceTapped: { _ in })
} 