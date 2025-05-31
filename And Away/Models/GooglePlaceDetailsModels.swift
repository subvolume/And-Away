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