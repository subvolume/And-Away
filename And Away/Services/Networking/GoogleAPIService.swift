import Foundation

// MARK: - Google API Service
class GoogleAPIService {
    static let shared = GoogleAPIService()
    
    private let networkService = NetworkService.shared
    private let baseURL = "https://maps.googleapis.com/maps/api"
    
    // Google API key
    private let apiKey = "AIzaSyD8ph4-zjHFk5JmPRoHNuBTNacwQi0x8IU"
    
    private init() {}
    
    // MARK: - Places Autocomplete
    func getPlaceAutocomplete(query: String) async throws -> GoogleAutocompleteResponse {
        guard !query.isEmpty else {
            throw GoogleAPIError.invalidInput
        }
        
        let urlString = "\(baseURL)/place/autocomplete/json"
        var components = URLComponents(string: urlString)!
        
        components.queryItems = [
            URLQueryItem(name: "input", value: query),
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        return try await networkService.request(
            url: url,
            responseType: GoogleAutocompleteResponse.self
        )
    }
    
    // MARK: - Place Details
    func getPlaceDetails(placeId: String) async throws -> GooglePlaceDetailsResponse {
        let urlString = "\(baseURL)/place/details/json"
        var components = URLComponents(string: urlString)!
        
        components.queryItems = [
            URLQueryItem(name: "place_id", value: placeId),
            URLQueryItem(name: "fields", value: "place_id,name,formatted_address,address_components,formatted_phone_number,international_phone_number,website,rating,user_ratings_total,price_level,photos,reviews,opening_hours,geometry,types,business_status,utc_offset"),
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        return try await networkService.request(
            url: url,
            responseType: GooglePlaceDetailsResponse.self
        )
    }
    
    // MARK: - Places Search (Nearby)
    func searchPlaces(
        location: String,
        radius: Int = 5000,
        type: String? = nil
    ) async throws -> GooglePlacesSearchResponse {
        
        let urlString = "\(baseURL)/place/nearbysearch/json"
        var components = URLComponents(string: urlString)!
        
        var queryItems = [
            URLQueryItem(name: "location", value: location),
            URLQueryItem(name: "radius", value: String(radius)),
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        if let type = type {
            queryItems.append(URLQueryItem(name: "type", value: type))
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        return try await networkService.request(
            url: url,
            responseType: GooglePlacesSearchResponse.self
        )
    }
    
    // MARK: - Places Text Search
    func searchPlacesByText(
        query: String,
        location: String? = nil,
        radius: Int? = nil
    ) async throws -> GooglePlacesSearchResponse {
        
        let urlString = "\(baseURL)/place/textsearch/json"
        var components = URLComponents(string: urlString)!
        
        var queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        // Add optional location bias
        if let location = location {
            queryItems.append(URLQueryItem(name: "location", value: location))
        }
        
        // Add optional radius
        if let radius = radius {
            queryItems.append(URLQueryItem(name: "radius", value: String(radius)))
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        return try await networkService.request(
            url: url,
            responseType: GooglePlacesSearchResponse.self
        )
    }
    
    // MARK: - Places Text Search with Details (Combined Method)
    func searchPlacesWithDetails(
        query: String,
        location: String? = nil,
        radius: Int? = nil,
        maxResults: Int = 10
    ) async throws -> [PlaceSearchResult] {
        
        // First, do a text search to get basic place results
        let searchResponse = try await searchPlacesByText(
            query: query,
            location: location,
            radius: radius
        )
        
        // Limit results to maxResults
        let limitedResults = Array(searchResponse.results.prefix(maxResults))
        
        // Fetch detailed information for each place to get address components
        var detailedResults: [PlaceSearchResult] = []
        
        // Fetch place details in parallel for better performance
        await withTaskGroup(of: PlaceSearchResult?.self) { group in
            for place in limitedResults {
                group.addTask {
                    do {
                        let detailsResponse = try await self.getPlaceDetails(placeId: place.placeId)
                        
                        // Create a PlaceSearchResult with detailed address components
                        return PlaceSearchResult(
                            placeId: place.placeId,
                            name: place.name,
                            vicinity: place.vicinity, // Keep original vicinity from text search
                            formattedAddress: detailsResponse.result.formattedAddress,
                            addressComponents: detailsResponse.result.addressComponents,
                            rating: place.rating,
                            priceLevel: place.priceLevel,
                            photos: place.photos,
                            geometry: place.geometry,
                            types: place.types,
                            userRatingsTotal: place.userRatingsTotal,
                            businessStatus: place.businessStatus
                        )
                    } catch {
                        // If place details fail, return the basic search result
                        return place
                    }
                }
            }
            
            // Collect results in order
            for await result in group {
                if let searchResult = result {
                    detailedResults.append(searchResult)
                }
            }
        }
        
        return detailedResults
    }
    
    // MARK: - Directions
    func getDirections(
        origin: String,
        destination: String,
        mode: TravelMode = .driving
    ) async throws -> GoogleDirectionsResponse {
        
        let urlString = "\(baseURL)/directions/json"
        var components = URLComponents(string: urlString)!
        
        components.queryItems = [
            URLQueryItem(name: "origin", value: origin),
            URLQueryItem(name: "destination", value: destination),
            URLQueryItem(name: "mode", value: mode.rawValue),
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        return try await networkService.request(
            url: url,
            responseType: GoogleDirectionsResponse.self
        )
    }
    
    // MARK: - Photo URL Builder
    func getPhotoURL(photoReference: String, maxWidth: Int = 400) -> URL? {
        let urlString = "\(baseURL)/place/photo"
        var components = URLComponents(string: urlString)!
        
        components.queryItems = [
            URLQueryItem(name: "photo_reference", value: photoReference),
            URLQueryItem(name: "maxwidth", value: String(maxWidth)),
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        return components.url
    }
}

// MARK: - Travel Modes
enum TravelMode: String, CaseIterable {
    case driving = "driving"
    case walking = "walking"
    case bicycling = "bicycling"
    case transit = "transit"
}

// MARK: - Google API Errors
enum GoogleAPIError: Error, LocalizedError {
    case invalidInput
    case apiKeyMissing
    case quotaExceeded
    case invalidRequest
    
    var errorDescription: String? {
        switch self {
        case .invalidInput:
            return "Invalid input provided"
        case .apiKeyMissing:
            return "Google API key is missing"
        case .quotaExceeded:
            return "API quota exceeded"
        case .invalidRequest:
            return "Invalid request to Google API"
        }
    }
} 