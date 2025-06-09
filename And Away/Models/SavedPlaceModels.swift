import Foundation
import CoreLocation

// MARK: - Saved Place Model
struct SavedPlace: Codable, Identifiable {
    let id = UUID()
    let placeId: String            // Google Place ID (permanent identifier)
    let name: String
    let address: String
    let location: PlaceLocation    // lat/lng coordinates
    let googleTypes: [String]      // Original Google types
    let category: PlaceCategory    // Auto-categorized for filtering
    let dateBookmarked: Date
    var notes: String              // User's personal notes (editable)
    let photoReference: String?    // Reference to best photo
    
    // Prepared for future AI features
    let context: BookmarkContext   // Why/when it was bookmarked
    
    // User interaction data (for recommendations)
    var userRating: Int?           // User's personal rating (1-5)
    var visitStatus: VisitStatus   // planned, visited, favorite
    var lastViewedDate: Date?      // When user last looked at this place
    
    init(from placeSearchResult: PlaceSearchResult, notes: String = "", context: BookmarkContext = .manual) {
        self.placeId = placeSearchResult.placeId
        self.name = placeSearchResult.name
        self.address = placeSearchResult.displayAddress
        self.location = placeSearchResult.geometry.location
        self.googleTypes = placeSearchResult.types
        self.category = PlaceCategory.categorize(from: placeSearchResult.types)
        self.dateBookmarked = Date()
        self.notes = notes
        self.photoReference = placeSearchResult.photos?.first?.photoReference
        self.context = context
        self.userRating = nil
        self.visitStatus = .planned
        self.lastViewedDate = nil
    }
    
    init(from placeDetails: PlaceDetails, notes: String = "", context: BookmarkContext = .manual) {
        self.placeId = placeDetails.placeId
        self.name = placeDetails.name
        self.address = placeDetails.formattedAddress ?? "Address not available"
        self.location = placeDetails.geometry.location
        self.googleTypes = placeDetails.types
        self.category = PlaceCategory.categorize(from: placeDetails.types)
        self.dateBookmarked = Date()
        self.notes = notes
        self.photoReference = placeDetails.photos?.first?.photoReference
        self.context = context
        self.userRating = nil
        self.visitStatus = .planned
        self.lastViewedDate = nil
    }
    
    // MARK: - Computed Properties
    /// Distance from user's current location (calculated when needed)
    func distanceFrom(_ userLocation: CLLocation) -> Double {
        let placeLocation = CLLocation(latitude: location.lat, longitude: location.lng)
        return userLocation.distance(from: placeLocation)
    }
    
    /// Formatted distance string
    func distanceStringFrom(_ userLocation: CLLocation) -> String {
        let distance = distanceFrom(userLocation)
        
        if distance < 1000 {
            return "\(Int(distance))m"
        } else {
            let kilometers = distance / 1000
            if kilometers < 10 {
                return String(format: "%.1fkm", kilometers)
            } else {
                return "\(Int(kilometers))km"
            }
        }
    }
    
    /// Get simple location name for display
    var simpleLocationName: String {
        // Extract city/area from address
        let components = address.components(separatedBy: ",")
        if components.count > 1 {
            return components[components.count - 2].trimmingCharacters(in: .whitespaces)
        }
        return address
    }
}

// MARK: - Place Category (Auto-categorized)
enum PlaceCategory: String, CaseIterable, Codable {
    case restaurant = "restaurant"
    case cafe = "cafe"
    case attraction = "attraction"
    case shopping = "shopping"
    case accommodation = "accommodation"
    case transport = "transport"
    case health = "health"
    case entertainment = "entertainment"
    case services = "services"
    case other = "other"
    
    var displayName: String {
        switch self {
        case .restaurant: return "Restaurants"
        case .cafe: return "Cafés"
        case .attraction: return "Attractions"
        case .shopping: return "Shopping"
        case .accommodation: return "Hotels"
        case .transport: return "Transport"
        case .health: return "Health"
        case .entertainment: return "Entertainment"
        case .services: return "Services"
        case .other: return "Other"
        }
    }
    

    
    /// Automatically categorize based on Google Places types
    static func categorize(from googleTypes: [String]) -> PlaceCategory {
        let types = googleTypes.map { $0.lowercased() }
        
        // Restaurant and food
        if types.contains(where: { foodTypes.contains($0) }) {
            return .restaurant
        }
        
        // Cafés and coffee
        if types.contains(where: { cafeTypes.contains($0) }) {
            return .cafe
        }
        
        // Tourist attractions and landmarks
        if types.contains(where: { attractionTypes.contains($0) }) {
            return .attraction
        }
        
        // Shopping
        if types.contains(where: { shoppingTypes.contains($0) }) {
            return .shopping
        }
        
        // Accommodation
        if types.contains(where: { accommodationTypes.contains($0) }) {
            return .accommodation
        }
        
        // Transport
        if types.contains(where: { transportTypes.contains($0) }) {
            return .transport
        }
        
        // Health and medical
        if types.contains(where: { healthTypes.contains($0) }) {
            return .health
        }
        
        // Entertainment
        if types.contains(where: { entertainmentTypes.contains($0) }) {
            return .entertainment
        }
        
        // Services
        if types.contains(where: { serviceTypes.contains($0) }) {
            return .services
        }
        
        return .other
    }
    
    // MARK: - Type Categories
    private static let foodTypes = [
        "restaurant", "food", "meal_takeaway", "meal_delivery",
        "bakery", "meal_restaurant", "establishment"
    ]
    
    private static let cafeTypes = [
        "cafe", "coffee", "coffee_shop"
    ]
    
    private static let attractionTypes = [
        "tourist_attraction", "museum", "amusement_park", "aquarium",
        "art_gallery", "church", "hindu_temple", "mosque", "synagogue",
        "park", "natural_feature", "zoo", "landmark"
    ]
    
    private static let shoppingTypes = [
        "shopping_mall", "store", "clothing_store", "electronics_store",
        "supermarket", "grocery_or_supermarket", "department_store",
        "jewelry_store", "shoe_store", "book_store", "furniture_store"
    ]
    
    private static let accommodationTypes = [
        "lodging", "hotel", "motel", "hostel", "resort"
    ]
    
    private static let transportTypes = [
        "airport", "bus_station", "subway_station", "train_station",
        "taxi_stand", "transit_station", "gas_station"
    ]
    
    private static let healthTypes = [
        "hospital", "pharmacy", "doctor", "dentist", "veterinary_care",
        "health", "medical"
    ]
    
    private static let entertainmentTypes = [
        "movie_theater", "night_club", "bowling_alley", "casino",
        "gym", "spa", "stadium"
    ]
    
    private static let serviceTypes = [
        "bank", "atm", "post_office", "police", "fire_station",
        "local_government_office", "embassy", "library"
    ]
}

// MARK: - Visit Status
enum VisitStatus: String, Codable {
    case planned = "planned"       // Want to visit
    case visited = "visited"       // Have been there
    case favorite = "favorite"     // Loved it, want to return
    
    var displayName: String {
        switch self {
        case .planned: return "Want to visit"
        case .visited: return "Visited"
        case .favorite: return "Favorite"
        }
    }
    
    var icon: String {
        switch self {
        case .planned: return "bookmark"
        case .visited: return "checkmark.circle"
        case .favorite: return "heart.fill"
        }
    }
}

// MARK: - Bookmark Context (Prepared for AI)
enum BookmarkContext: String, Codable {
    case manual = "manual"                    // User manually bookmarked
    case recommendation = "recommendation"    // From AI recommendation
    case nearby = "nearby"                   // Found while exploring nearby
    case search = "search"                   // Found through search
    case social = "social"                   // Shared from friend/social media
    
    var displayName: String {
        switch self {
        case .manual: return "Manually saved"
        case .recommendation: return "Recommended"
        case .nearby: return "Found nearby"
        case .search: return "Found in search"
        case .social: return "Shared"
        }
    }
}

// MARK: - Search and Filter Helpers (Prepared for future)
extension Array where Element == SavedPlace {
    
    /// Filter by category
    func filtered(by category: PlaceCategory) -> [SavedPlace] {
        return self.filter { $0.category == category }
    }
    
    /// Filter by visit status
    func filtered(by status: VisitStatus) -> [SavedPlace] {
        return self.filter { $0.visitStatus == status }
    }
    
    /// Search by name or notes
    func searched(query: String) -> [SavedPlace] {
        guard !query.isEmpty else { return self }
        let lowercaseQuery = query.lowercased()
        return self.filter { place in
            place.name.lowercased().contains(lowercaseQuery) ||
            place.notes.lowercased().contains(lowercaseQuery) ||
            place.address.lowercased().contains(lowercaseQuery)
        }
    }
    
    /// Sort by distance from location
    func sorted(by userLocation: CLLocation) -> [SavedPlace] {
        return self.sorted { place1, place2 in
            place1.distanceFrom(userLocation) < place2.distanceFrom(userLocation)
        }
    }
    
    /// Sort by date bookmarked (newest first)
    func sortedByDateBookmarked() -> [SavedPlace] {
        return self.sorted { $0.dateBookmarked > $1.dateBookmarked }
    }
} 