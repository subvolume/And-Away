import Foundation
import GooglePlacesSwift
import CoreLocation
import GoogleMaps

/// Mock implementation of PlacesService for previews and testing
@MainActor
class MockPlacesService: PlacesService {
    
    func searchPlaces(
        query: String,
        userLocation: CLLocationCoordinate2D?,
        mapVisibleRegion: GMSVisibleRegion?,
        mapZoom: Float
    ) async -> Result<[Place], PlacesError> {
        // Return empty results for mock
        return .success([])
    }
    
    func fetchPlace(placeID: String) async -> Result<Place, PlacesError> {
        // Return error for mock
        return .failure(.placeNotFound)
    }
    
    func nearbySearch(
        includedTypes: [String],
        userLocation: CLLocationCoordinate2D,
        radius: Double
    ) async -> Result<[Place], PlacesError> {
        // Return empty results for mock - Place type doesn't have public initializers
        return .success([])
    }
} 