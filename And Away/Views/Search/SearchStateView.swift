import SwiftUI

struct SearchStateView: View {
    @Binding var searchText: String
    
    var body: some View {
        VStack {
            if searchText.isEmpty {
                SearchEmptyStateView()
            } else {
                SearchResultsView(searchText: searchText)
            }
        }
    }
}

#Preview {
    SearchStateView(searchText: .constant(""))
} 