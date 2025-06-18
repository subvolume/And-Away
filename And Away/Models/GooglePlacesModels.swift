import Foundation
import CoreLocation

// MARK: - Core Place Model
struct GooglePlace: Codable, Identifiable {
    let id = UUID()
    let placeId: String
    let name: String
    let vicinity: String?
    let types: [String]
    
    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case name
        case vicinity
        case types
    }
}

// MARK: - Place Location
struct PlaceLocation: Codable {
    let lat: Double
    let lng: Double
}

// MARK: - Place Photos
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

// MARK: - Autocomplete API
struct GoogleAutocompleteResponse: Codable {
    let predictions: [AutocompletePrediction]
    let status: String
}

struct AutocompletePrediction: Codable, Identifiable {
    let id = UUID()
    let placeId: String
    let description: String
    let structuredFormatting: StructuredFormatting
    let types: [String]
    
    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case description
        case structuredFormatting = "structured_formatting"
        case types
    }
}

struct StructuredFormatting: Codable {
    let mainText: String
    let secondaryText: String?
    
    enum CodingKeys: String, CodingKey {
        case mainText = "main_text"
        case secondaryText = "secondary_text"
    }
}

// MARK: - Text Search API
struct GooglePlacesSearchResponse: Codable {
    let results: [PlaceSearchResult]
    let status: String
}

struct PlaceSearchResult: Codable, Identifiable {
    let id = UUID()
    let placeId: String
    let name: String
    let vicinity: String?
    let types: [String]
    
    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case name
        case vicinity
        case types
    }
}

struct PlaceGeometry: Codable {
    let location: PlaceLocation
    let viewport: PlaceViewport?
}

struct PlaceViewport: Codable {
    let northeast: PlaceLocation
    let southwest: PlaceLocation
}

// MARK: - Place Details API Response
struct GooglePlaceDetailsResponse: Codable {
    let result: PlaceDetails
    let status: String
}

struct PlaceDetails: Codable, Identifiable {
    let id = UUID()
    let placeId: String
    let name: String
    let formattedAddress: String?
    let formattedPhoneNumber: String?
    let website: String?
    let rating: Double?
    let userRatingsTotal: Int?
    let priceLevel: Int?
    let photos: [PlacePhoto]?
    let reviews: [PlaceReview]?
    let openingHours: OpeningHours?
    let geometry: PlaceGeometry
    let types: [String]
    let businessStatus: String?
    
    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case name
        case formattedAddress = "formatted_address"
        case formattedPhoneNumber = "formatted_phone_number"
        case website
        case rating
        case userRatingsTotal = "user_ratings_total"
        case priceLevel = "price_level"
        case photos
        case reviews
        case openingHours = "opening_hours"
        case geometry
        case types
        case businessStatus = "business_status"
    }
}

struct PlaceReview: Codable, Identifiable {
    let id = UUID()
    let authorName: String
    let rating: Int
    let relativeTimeDescription: String
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case authorName = "author_name"
        case rating
        case relativeTimeDescription = "relative_time_description"
        case text
    }
}

struct OpeningHours: Codable {
    let openNow: Bool?
    let weekdayText: [String]?
    
    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
        case weekdayText = "weekday_text"
    }
} 