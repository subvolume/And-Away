import Foundation
import GooglePlacesSwift
import CoreLocation

// MARK: - Places Service Protocol
protocol PlacesService {
    func searchPlaces(query: String, userLocation: CLLocationCoordinate2D?) async -> Result<[Place], PlacesError>
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
    
    func searchPlaces(query: String, userLocation: CLLocationCoordinate2D?) async -> Result<[Place], PlacesError> {
        // Use user location if available, otherwise fall back to a default
        let locationBias: CircularCoordinateRegion
        
        if let userLocation = userLocation {
            // Use user's actual location
            locationBias = CircularCoordinateRegion(
                center: userLocation,
                radius: 50000 // 50km radius
            )
        } else {
            // Fallback to San Francisco area if user location unavailable
            locationBias = CircularCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                radius: 50000 // 50km radius
            )
        }
        
        let searchByTextRequest = SearchByTextRequest(
            textQuery: query,
            placeProperties: [.displayName, .placeID, .formattedAddress, .coordinate, .rating, .numberOfUserRatings],
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
            placeProperties: [.displayName, .formattedAddress, .rating, .numberOfUserRatings, .photos, .coordinate, .internationalPhoneNumber, .websiteURL]
        )
        
        switch await placesClient.fetchPlace(with: fetchPlaceRequest) {
        case .success(let place):
            return .success(place)
        case .failure(let placesError):
            return .failure(.unknown(placesError))
        }
    }
} 