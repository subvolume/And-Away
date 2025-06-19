import Foundation
import CoreLocation
import GooglePlacesSwift

@MainActor
class GooglePlacesService: ObservableObject {
    
    private let placesClient = PlacesClient.shared
    
    // Default location bias (San Francisco) when user location is unavailable
    private let defaultLocationBias = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    private let defaultRadius: Double = 50000 // 50km in meters
    
    @Published var isLoading = false
    @Published var lastError: Error?
    
    /// Search for places using text query
    /// - Parameters:
    ///   - text: Search query (e.g., "coffee shops", "pizza near me")
    ///   - userLocation: User's current location for bias, or nil to use default
    /// - Returns: Array of unified Place objects
    func search(text: String, userLocation: CLLocationCoordinate2D? = nil) async throws -> [Place] {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return []
        }
        
        isLoading = true
        lastError = nil
        
        defer {
            isLoading = false
        }
        
        do {
            // Create location bias (always required, ≤ 50km circle)
            let biasLocation = userLocation ?? defaultLocationBias
            let locationBias = CircularCoordinateRegion(
                center: biasLocation,
                radius: defaultRadius
            )
            
            // Create search request with minimal field mask
            let request = SearchByTextRequest(
                textQuery: text,
                placeProperties: [
                    .placeID,
                    .displayName,
                    .formattedAddress,
                    .coordinate
                ],
                locationBias: locationBias,
                maxResultCount: 20
            )
            
            // Perform search
            let result = await placesClient.searchByText(with: request)
            
            // Handle the result
            switch result {
            case .success(let places):
                // Convert Google places to our unified model
                let convertedPlaces = GooglePlaceAdapter.convert(places)
                print("✅ GooglePlacesService: Found \(convertedPlaces.count) places for '\(text)'")
                return convertedPlaces
                
            case .failure(let error):
                lastError = error
                print("❌ GooglePlacesService error: \(error)")
                throw error
            }
            
        } catch {
            lastError = error
            print("❌ GooglePlacesService error: \(error)")
            throw error
        }
    }
} 