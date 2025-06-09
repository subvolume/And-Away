import Foundation

// MARK: - Google Place Details Response
struct GooglePlaceDetailsResponse: Codable {
    let result: PlaceDetails
    let status: String
}

// MARK: - Complete Place Details
struct PlaceDetails: Codable, Identifiable {
    let id = UUID()
    let placeId: String
    let name: String
    let formattedAddress: String?
    let addressComponents: [AddressComponent]?
    let formattedPhoneNumber: String?
    let internationalPhoneNumber: String?
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
    let utcOffset: Int?
    
    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case name
        case formattedAddress = "formatted_address"
        case addressComponents = "address_components"
        case formattedPhoneNumber = "formatted_phone_number"
        case internationalPhoneNumber = "international_phone_number"
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
        case utcOffset = "utc_offset"
    }
    
    // MARK: - Computed Properties
    /// Get a clean location name from address components
    var simpleLocationName: String {
        guard let addressComponents = addressComponents else {
            // Fallback to formatted address
            return formattedAddress ?? "Unknown location"
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

// MARK: - Address Component
struct AddressComponent: Codable {
    let longName: String
    let shortName: String
    let types: [String]
    
    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case shortName = "short_name"
        case types
    }
}

// MARK: - Place Reviews
struct PlaceReview: Codable, Identifiable {
    let id = UUID()
    let authorName: String
    let authorUrl: String?
    let language: String?
    let profilePhotoUrl: String?
    let rating: Int
    let relativeTimeDescription: String
    let text: String
    let time: Int
    
    enum CodingKeys: String, CodingKey {
        case authorName = "author_name"
        case authorUrl = "author_url"
        case language
        case profilePhotoUrl = "profile_photo_url"
        case rating
        case relativeTimeDescription = "relative_time_description"
        case text
        case time
    }
}

// MARK: - Opening Hours
struct OpeningHours: Codable {
    let openNow: Bool?
    let periods: [OpeningPeriod]?
    let weekdayText: [String]?
    
    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
        case periods
        case weekdayText = "weekday_text"
    }
}

struct OpeningPeriod: Codable {
    let close: DayTime?
    let open: DayTime
}

struct DayTime: Codable {
    let day: Int
    let time: String
} 