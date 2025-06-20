import SwiftUI
import CoreLocation

struct SearchStateView: View {
    @Binding var searchText: String
    let userLocation: CLLocationCoordinate2D?
    let onPlaceTapped: (String, String?) -> Void
    
    var body: some View {
        VStack {
            if searchText.isEmpty {
                SearchEmptyStateView()
            } else {
                SearchResultsView(
                    searchText: searchText, 
                    userLocation: userLocation,
                    onPlaceTapped: onPlaceTapped
                )
            }
        }
    }
}

#Preview {
    SearchStateView(
        searchText: .constant(""),
        userLocation: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        onPlaceTapped: { _, _ in }
    )
} 