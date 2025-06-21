import SwiftUI
import CoreLocation
import GoogleMaps

struct SearchStateView: View {
    @Binding var searchText: String
    let userLocation: CLLocationCoordinate2D?
    let mapVisibleRegion: GMSVisibleRegion?
    let mapZoom: Float
    let onPlaceTapped: (String, String?) -> Void
    
    var body: some View {
        VStack {
            if searchText.isEmpty {
                SearchEmptyStateView()
            } else {
                SearchResultsView(
                    searchText: searchText, 
                    userLocation: userLocation,
                    mapVisibleRegion: mapVisibleRegion,
                    mapZoom: mapZoom,
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
        mapVisibleRegion: nil,
        mapZoom: 15.0,
        onPlaceTapped: { _, _ in }
    )
} 