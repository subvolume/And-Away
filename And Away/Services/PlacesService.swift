import Foundation
import GooglePlacesSwift
import CoreLocation
import GoogleMaps

// MARK: - Places Service Protocol
protocol PlacesService {
    func searchPlaces(
        query: String, 
        userLocation: CLLocationCoordinate2D?,
        mapVisibleRegion: GMSVisibleRegion?,
        mapZoom: Float
    ) async -> Result<[Place], PlacesError>
    func fetchPlace(placeID: String) async -> Result<Place, PlacesError>
}

// MARK: - Places Error
enum PlacesError: Error, LocalizedError {
    case searchFailed(String)
    case placeNotFound
    case networkError
    case invalidAPIKey
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .searchFailed(let message):
            return "Search failed: \(message)"
        case .placeNotFound:
            return "Place not found"
        case .networkError:
            return "Network connection error"
        case .invalidAPIKey:
            return "Invalid API key"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}

// MARK: - Google Places Service Implementation
@MainActor
class GooglePlacesService: PlacesService {
    
    private let placesClient = PlacesClient.shared
    
    func searchPlaces(
        query: String, 
        userLocation: CLLocationCoordinate2D?,
        mapVisibleRegion: GMSVisibleRegion?,
        mapZoom: Float
    ) async -> Result<[Place], PlacesError> {
        // Determine location bias based on map state
        let locationBias: CircularCoordinateRegion
        
        if let visibleRegion = mapVisibleRegion {
            // Use smart bias based on visible map and zoom level
            locationBias = LocationBiasHelper.createSearchBias(
                visibleRegion: visibleRegion,
                zoom: mapZoom,
                userLocation: userLocation
            )
        } else if let userLocation = userLocation {
            // Fallback to user location with zoom-based radius
            let radius = LocationBiasHelper.searchRadius(for: mapZoom)
            locationBias = CircularCoordinateRegion(
                center: userLocation,
                radius: radius
            )
        } else {
            // Last resort: Use a default location (could be based on device locale)
            // For now, using a wider radius around a neutral point
            locationBias = CircularCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                radius: 100000 // 100km - very wide
            )
        }
        
        let searchByTextRequest = SearchByTextRequest(
            textQuery: query,
            placeProperties: [.displayName, .placeID, .formattedAddress, .coordinate, .rating, .numberOfUserRatings, .types],
            locationBias: locationBias
        )
        
        switch await placesClient.searchByText(with: searchByTextRequest) {
        case .success(let places):
            return .success(places)
        case .failure(let placesError):
            return .failure(.unknown(placesError))
        }
    }
    
    func fetchPlace(placeID: String) async -> Result<Place, PlacesError> {
        let fetchPlaceRequest = FetchPlaceRequest(
            placeID: placeID,
            placeProperties: [.displayName, .formattedAddress, .rating, .numberOfUserRatings, .photos, .coordinate, .internationalPhoneNumber, .websiteURL, .types]
        )
        
        switch await placesClient.fetchPlace(with: fetchPlaceRequest) {
        case .success(let place):
            return .success(place)
        case .failure(let placesError):
            return .failure(.unknown(placesError))
        }
    }
} 