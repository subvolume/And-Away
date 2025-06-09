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
            // Fallback to parsing vicinity or formatted address
            if let vicinity = vicinity, !vicinity.isEmpty {
                let components = vicinity.components(separatedBy: ",")
                if let firstPart = components.first?.trimmingCharacters(in: .whitespaces), !firstPart.isEmpty {
                    return firstPart
                }
            }
            
            if let formattedAddress = formattedAddress, !formattedAddress.isEmpty {
                let components = formattedAddress.components(separatedBy: ",")
                if components.count >= 2 {
                    return components[components.count - 2].trimmingCharacters(in: .whitespaces)
                }
            }
            
            return "Unknown location"
        }
        
        // Try to find neighborhood first
        if let neighborhood = addressComponents.first(where: { $0.types.contains("neighborhood") }) {
            return neighborhood.longName
        }
        
        // Then try sublocality
        if let sublocality = addressComponents.first(where: { $0.types.contains("sublocality") }) {
            return sublocality.longName
        }
        
        // Then try locality (city)
        if let locality = addressComponents.first(where: { $0.types.contains("locality") }) {
            return locality.longName
        }
        
        // Fallback to administrative area
        if let adminArea = addressComponents.first(where: { $0.types.contains("administrative_area_level_1") }) {
            return adminArea.longName
        }
        
        // Final fallback to formatted address
        return formattedAddress ?? "Unknown location"
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