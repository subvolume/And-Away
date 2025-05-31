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
        case rating
        case priceLevel = "price_level"
        case photos
        case geometry
        case types
        case userRatingsTotal = "user_ratings_total"
        case businessStatus = "business_status"
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