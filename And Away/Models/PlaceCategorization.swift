import Foundation

// MARK: - Place Categorization System

/// Handles categorization of places and their visual representation
/// Maps Google Place types to our app's styling system
struct PlaceCategorization {
    
    /// Get category information for a place type
    static func category(for placeType: String) -> PlaceCategory {
        // Normalize the place type (remove underscores, lowercase)
        let normalizedType = placeType.lowercased().replacingOccurrences(of: "_", with: "")
        
        // Find matching category
        for categoryMapping in categoryMappings {
            if categoryMapping.types.contains(normalizedType) || categoryMapping.types.contains(placeType) {
                return PlaceCategory(
                    primaryType: placeType,
                    displayName: categoryMapping.displayName,
                    icon: categoryMapping.icon,
                    color: categoryMapping.color
                )
            }
        }
        
        // Return default category if no match found
        return PlaceCategory.unknown
    }
    
    /// Get all available categories for filtering
    static var allCategories: [PlaceCategory] {
        return categoryMappings.map { mapping in
            PlaceCategory(
                primaryType: mapping.types.first ?? "unknown",
                displayName: mapping.displayName,
                icon: mapping.icon,
                color: mapping.color
            )
        }
    }
}

// MARK: - Category Mappings

private struct CategoryMapping {
    let types: [String]
    let displayName: String
    let icon: String
    let color: String
}

private let categoryMappings: [CategoryMapping] = [
    
    // Food & Drink
    CategoryMapping(
        types: ["restaurant", "meal_takeaway", "meal_delivery", "food"],
        displayName: "Restaurant",
        icon: "fork.knife",
        color: "orange"
    ),
    CategoryMapping(
        types: ["cafe", "bakery", "coffee_shop"],
        displayName: "Café",
        icon: "cup.and.saucer.fill",
        color: "brown"
    ),
    CategoryMapping(
        types: ["bar", "night_club", "liquor_store"],
        displayName: "Bar",
        icon: "wineglass.fill",
        color: "purple"
    ),
    
    // Shopping
    CategoryMapping(
        types: ["shopping_mall", "department_store", "clothing_store", "store"],
        displayName: "Shopping",
        icon: "bag.fill",
        color: "pink"
    ),
    CategoryMapping(
        types: ["supermarket", "grocery_or_supermarket", "convenience_store"],
        displayName: "Grocery",
        icon: "cart.fill",
        color: "green"
    ),
    CategoryMapping(
        types: ["pharmacy", "drugstore"],
        displayName: "Pharmacy",
        icon: "cross.case.fill",
        color: "red"
    ),
    
    // Entertainment
    CategoryMapping(
        types: ["movie_theater", "cinema"],
        displayName: "Cinema",
        icon: "tv.fill",
        color: "blue"
    ),
    CategoryMapping(
        types: ["amusement_park", "tourist_attraction", "zoo"],
        displayName: "Attraction",
        icon: "star.fill",
        color: "yellow"
    ),
    CategoryMapping(
        types: ["gym", "fitness", "spa"],
        displayName: "Fitness",
        icon: "figure.run",
        color: "mint"
    ),
    
    // Services
    CategoryMapping(
        types: ["hospital", "doctor", "dentist", "veterinary_care"],
        displayName: "Healthcare",
        icon: "cross.fill",
        color: "red"
    ),
    CategoryMapping(
        types: ["bank", "atm", "finance"],
        displayName: "Bank",
        icon: "banknote.fill",
        color: "green"
    ),
    CategoryMapping(
        types: ["gas_station", "fuel"],
        displayName: "Gas Station",
        icon: "fuelpump.fill",
        color: "blue"
    ),
    
    // Transportation
    CategoryMapping(
        types: ["subway_station", "train_station", "transit_station"],
        displayName: "Transit",
        icon: "tram.fill",
        color: "blue"
    ),
    CategoryMapping(
        types: ["airport"],
        displayName: "Airport",
        icon: "airplane",
        color: "blue"
    ),
    CategoryMapping(
        types: ["parking"],
        displayName: "Parking",
        icon: "parkingsign",
        color: "gray"
    ),
    
    // Accommodation
    CategoryMapping(
        types: ["lodging", "hotel", "motel"],
        displayName: "Hotel",
        icon: "bed.double.fill",
        color: "blue"
    ),
    
    // Education & Culture
    CategoryMapping(
        types: ["school", "university", "library"],
        displayName: "Education",
        icon: "book.fill",
        color: "blue"
    ),
    CategoryMapping(
        types: ["museum", "art_gallery"],
        displayName: "Museum",
        icon: "building.columns.fill",
        color: "purple"
    ),
    
    // Religious
    CategoryMapping(
        types: ["church", "mosque", "synagogue", "hindu_temple", "place_of_worship"],
        displayName: "Worship",
        icon: "building.fill",
        color: "purple"
    ),
    
    // Outdoor & Recreation
    CategoryMapping(
        types: ["park", "campground", "rv_park"],
        displayName: "Park",
        icon: "tree.fill",
        color: "green"
    ),
    CategoryMapping(
        types: ["beach", "natural_feature"],
        displayName: "Nature",
        icon: "leaf.fill",
        color: "green"
    ),
    
    // Government & Civic
    CategoryMapping(
        types: ["city_hall", "courthouse", "police", "fire_station", "post_office"],
        displayName: "Government",
        icon: "building.2.fill",
        color: "gray"
    )
]

// MARK: - Color Extensions

extension PlaceCategorization {
    
    /// Get color for a category using our existing color system
    static func colorToken(for category: PlaceCategory) -> String {
        switch category.color {
        case "orange": return "accent" // Use your existing ColorTokens
        case "brown": return "secondary"
        case "purple": return "accent"
        case "pink": return "accent"
        case "green": return "success"
        case "red": return "error"
        case "blue": return "primary"
        case "yellow": return "warning"
        case "mint": return "success"
        case "gray": return "neutral"
        default: return "neutral"
        }
    }
}

// MARK: - Popular Categories

extension PlaceCategorization {
    
    /// Categories commonly searched for - useful for quick filters
    static var popularCategories: [PlaceCategory] {
        let popularTypes = [
            "restaurant", "cafe", "bar", "shopping_mall", 
            "supermarket", "hospital", "gas_station", "park"
        ]
        
        return popularTypes.compactMap { type in
            categoryMappings.first { mapping in
                mapping.types.contains(type)
            }.map { mapping in
                PlaceCategory(
                    primaryType: type,
                    displayName: mapping.displayName,
                    icon: mapping.icon,
                    color: mapping.color
                )
            }
        }
    }
} 