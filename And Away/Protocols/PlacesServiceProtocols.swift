//
//  PlacesServiceProtocols.swift
//  And Away
//
//  Provider-agnostic protocols for places services
//

import Foundation
import CoreLocation

// MARK: - Core Service Protocols

/// Protocol for searching places
protocol PlacesSearchService {
    
    /// Search for places using text query
    /// - Parameters:
    ///   - query: Search text (e.g., "coffee", "Italian restaurant")
    ///   - location: User's current location for proximity search
    ///   - radius: Search radius in meters (optional)
    /// - Returns: Organized search results with scoring and categorization
    func searchPlaces(
        query: String,
        location: CLLocation?,
        radius: Double?
    ) async throws -> OrganizedSearchResults
    
    /// Search for nearby places within a specific category
    /// - Parameters:
    ///   - category: Place category to filter by
    ///   - location: Center point for search
    ///   - radius: Search radius in meters
    /// - Returns: Places matching the category within the radius
    func nearbyPlaces(
        category: PlaceCategory?,
        location: CLLocation,
        radius: Double
    ) async throws -> [Place]
    
    /// Search for places by name with autocomplete-style results
    /// - Parameters:
    ///   - partialName: Partial name or text input
    ///   - location: User location for proximity weighting
    /// - Returns: Places that match the partial name, sorted by relevance
    func searchByName(
        partialName: String,
        location: CLLocation?
    ) async throws -> [Place]
}

/// Protocol for getting detailed place information
protocol PlaceDetailsService {
    
    /// Get detailed information for a specific place
    /// - Parameter placeId: Unique identifier for the place
    /// - Returns: Complete place information with all available details
    func getPlaceDetails(placeId: String) async throws -> Place
    
    /// Get multiple place details efficiently
    /// - Parameter placeIds: Array of place identifiers
    /// - Returns: Dictionary mapping place IDs to Place objects
    func getMultiplePlaceDetails(placeIds: [String]) async throws -> [String: Place]
}

/// Protocol for autocomplete suggestions
protocol AutocompleteService {
    
    /// Get autocomplete suggestions for search text
    /// - Parameters:
    ///   - input: Partial text input from user
    ///   - location: User location for biasing results
    /// - Returns: Array of autocomplete suggestions
    func getAutocompleteSuggestions(
        input: String,
        location: CLLocation?
    ) async throws -> [AutocompleteSuggestion]
}

/// Protocol for directions and routing
protocol DirectionsService {
    
    /// Get directions from one place to another
    /// - Parameters:
    ///   - origin: Starting location
    ///   - destination: Destination place
    ///   - transportMode: Mode of transport (driving, walking, transit)
    /// - Returns: Route information with steps and duration
    func getDirections(
        from origin: CLLocation,
        to destination: Place,
        transportMode: TransportMode
    ) async throws -> ProtocolRouteInfo
}

/// Protocol for location services
protocol LocationService {
    
    /// Get user's current location
    /// - Returns: Current location with accuracy information
    func getCurrentLocation() async throws -> CLLocation
    
    /// Request location permissions if needed
    /// - Returns: Whether permission was granted
    func requestLocationPermission() async -> Bool
    
    /// Check current location authorization status
    var locationAuthorizationStatus: CLAuthorizationStatus { get }
}

// MARK: - Supporting Types

/// Autocomplete suggestion result
struct AutocompleteSuggestion {
    let id: String
    let displayText: String
    let secondaryText: String?
    let type: SuggestionType
}

enum SuggestionType {
    case place
    case address
    case category
}

/// Transport mode for directions
enum TransportMode {
    case driving
    case walking
    case transit
    case cycling
}

/// Route information for our protocol system
struct ProtocolRouteInfo {
    let duration: TimeInterval
    let distance: Double
    let steps: [ProtocolRouteStep]
}

struct ProtocolRouteStep {
    let instruction: String
    let distance: Double
    let duration: TimeInterval
} 