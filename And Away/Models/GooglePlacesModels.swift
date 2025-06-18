import Foundation
import CoreLocation

// MARK: - Core Place Model
struct GooglePlace: Codable, Identifiable {
    let id = UUID()
    let placeId: String
    let name: String
    let vicinity: String?
    let types: [String]
    let location: PlaceLocation?
    let photos: [PlacePhoto]?
    let formattedPhoneNumber: String?
    let openingHours: OpeningHours?
    
    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case name
        case vicinity
        case types
        case location
        case photos
        case formattedPhoneNumber = "formatted_phone_number"
        case openingHours = "opening_hours"
    }
}

// MARK: - Place Location (GPS Coordinates)
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

// MARK: - Opening Hours
struct OpeningHours: Codable {
    let openNow: Bool?
    let weekdayText: [String]?
    
    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
        case weekdayText = "weekday_text"
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
    let geometry: PlaceGeometry
    let photos: [PlacePhoto]?
    
    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case name
        case vicinity
        case types
        case geometry
        case photos
    }
}

struct PlaceGeometry: Codable {
    let location: PlaceLocation
}

// MARK: - Place Details API (for phone numbers and hours)
struct GooglePlaceDetailsResponse: Codable {
    let result: PlaceDetails
    let status: String
}

struct PlaceDetails: Codable, Identifiable {
    let id = UUID()
    let placeId: String
    let name: String
    let vicinity: String?
    let types: [String]
    let geometry: PlaceGeometry
    let photos: [PlacePhoto]?
    let formattedPhoneNumber: String?
    let openingHours: OpeningHours?
    
    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case name
        case vicinity
        case types
        case geometry
        case photos
        case formattedPhoneNumber = "formatted_phone_number"
        case openingHours = "opening_hours"
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