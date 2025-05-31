import SwiftUI

struct SearchStateView: View {
    @Binding var searchText: String
    let onPlaceTapped: () -> Void
    
    var body: some View {
        VStack {
            if searchText.isEmpty {
                SearchEmptyStateView()
            } else {
                SearchResultsView(searchText: searchText, onPlaceTapped: onPlaceTapped)
            }
        }
    }
}

#Preview {
    SearchStateView(searchText: .constant(""), onPlaceTapped: {})
} 