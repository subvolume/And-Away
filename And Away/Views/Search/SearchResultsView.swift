import SwiftUI

struct SearchResultsView: View {
    let searchText: String
    let onPlaceTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Use existing SectionHeaderView component
            SectionHeaderView(
                title: "Results for \"\(searchText)\"",
                showViewAllButton: false
            )
            
            // Use the searchResult template from ListItem
            ForEach(0..<5, id: \.self) { index in
                Button(action: onPlaceTapped) {
                    ListItem.searchResult(
                        title: "Place \(index + 1)",
                        distance: "\(Int.random(in: 1...20))km",
                        location: "Barcelona",
                        icon: Image(systemName: "building.columns"),
                        iconColor: .azure100
                    )
                }
                .buttonStyle(PlainButtonStyle()) // Removes default button styling
            }
            
            Spacer()
        }
    }
}

#Preview {
    SearchResultsView(searchText: "test search", onPlaceTapped: {})
} 