import Foundation

// MARK: - Google Places Search Response
struct GooglePlacesSearchResponse: Codable {
    let results: [PlaceSearchResult]
    let status: String
    let nextPageToken: String?
    
    enum CodingKeys: String, CodingKey {
        case results
        case status
        case nextPageToken = "next_page_token"
    }
}

// MARK: - Individual Place Search Result
struct PlaceSearchResult: Codable, Identifiable {
    let id = UUID()
    let placeId: String
    let name: String
    let vicinity: String?
    let formattedAddress: String?
    let addressComponents: [AddressComponent]?
    let rating: Double?
    let priceLevel: Int?
    let photos: [PlacePhoto]?
    let geometry: PlaceGeometry
    let types: [String]
    let userRatingsTotal: Int?
    let businessStatus: String?
    
    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case name
        case vicinity
        case formattedAddress = "formatted_address"
        case addressComponents = "address_components"
        case rating
        case priceLevel = "price_level"
        case photos
        case geometry
        case types
        case userRatingsTotal = "user_ratings_total"
        case businessStatus = "business_status"
    }
    
    // MARK: - Computed Properties
    /// Returns the best available address string
    var displayAddress: String {
        if let vicinity = vicinity, !vicinity.isEmpty {
            return vicinity
        } else if let formattedAddress = formattedAddress, !formattedAddress.isEmpty {
            return formattedAddress
        } else {
            return "Location not available"
        }
    }
    
    /// Get a clean location name from address components
    var simpleLocationName: String {
        guard let addressComponents = addressComponents else {
            // Fallback to vicinity if address components are not available
            if let vicinity = vicinity, !vicinity.isEmpty {
                // Try to extract a meaningful location from vicinity
                let components = vicinity.components(separatedBy: ",")
                // Take the last meaningful component (usually city/area name)
                if let lastComponent = components.last?.trimmingCharacters(in: .whitespaces), !lastComponent.isEmpty {
                    return lastComponent
                }
            }
            return "Unknown location"
        }
        
        // Priority order for worldwide compatibility:
        // 1. Locality (standard city/town name in most countries)
        if let locality = addressComponents.first(where: { $0.types.contains("locality") }) {
            return locality.longName
        }
        
        // 2. Postal town (used in UK and some other countries)
        if let postalTown = addressComponents.first(where: { $0.types.contains("postal_town") }) {
            return postalTown.longName
        }
        
        // 3. Administrative area level 3 (district level in many countries)
        if let adminLevel3 = addressComponents.first(where: { $0.types.contains("administrative_area_level_3") }) {
            return adminLevel3.longName
        }
        
        // 4. Sublocality level 1 (used in Asia and other regions)
        if let sublocalityLevel1 = addressComponents.first(where: { $0.types.contains("sublocality_level_1") }) {
            return sublocalityLevel1.longName
        }
        
        // 5. Neighborhood (very specific local area)
        if let neighborhood = addressComponents.first(where: { $0.types.contains("neighborhood") }) {
            return neighborhood.longName
        }
        
        // 6. Any sublocality as broader fallback
        if let sublocality = addressComponents.first(where: { $0.types.contains("sublocality") }) {
            return sublocality.longName
        }
        
        // 7. Administrative area level 2 (county/state level - broader but still meaningful)
        if let adminLevel2 = addressComponents.first(where: { $0.types.contains("administrative_area_level_2") }) {
            return adminLevel2.longName
        }
        
        // Final fallback - avoid administrative_area_level_1 (state/province) as it's too broad
        return "Unknown location"
    }
}

// MARK: - Place Photo Reference
struct PlacePhoto: Codable {
    let photoReference: String
    let height: Int
    let width: Int
    
    enum CodingKeys: String, CodingKey {
        case photoReference = "photo_reference"
        case height
        case width
    }
}

// MARK: - Place Location Info
struct PlaceGeometry: Codable {
    let location: PlaceLocation
    let viewport: PlaceViewport?
}

struct PlaceLocation: Codable {
    let lat: Double
    let lng: Double
}

struct PlaceViewport: Codable {
    let northeast: PlaceLocation
    let southwest: PlaceLocation
} 