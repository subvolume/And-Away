//
//  CategoryRegistry.swift
//  And Away
//
//  Centralized category management system
//

import SwiftUI

// MARK: - Category Registry

/// Centralized registry for all place categories
struct CategoryRegistry {
    
    // MARK: - Core Categories
    
    /// All available place categories
    static let allCategories: [PlaceCategory] = [
        PlaceCategory(
            id: "restaurant",
            displayName: "Restaurant",
            icon: "fork.knife",
            color: .orange100,
            priority: 1
        ),
        PlaceCategory(
            id: "coffee_shop",
            displayName: "Coffee Shop",
            icon: "cup.and.saucer.fill",
            color: .teal100,
            priority: 2
        ),
        PlaceCategory(
            id: "park",
            displayName: "Park",
            icon: "tree.fill",
            color: .green100,
            priority: 3
        ),
        PlaceCategory(
            id: "museum",
            displayName: "Museum",
            icon: "building.columns.fill",
            color: .purple100,
            priority: 4
        ),
        PlaceCategory(
            id: "shopping",
            displayName: "Shopping",
            icon: "bag.fill",
            color: .azure100,
            priority: 5
        ),
        PlaceCategory(
            id: "hotel",
            displayName: "Hotel",
            icon: "bed.double.fill",
            color: .indigo,
            priority: 6
        )
    ]
    
    // MARK: - Lookup Methods
    
    /// Get category by ID
    static func category(for id: String) -> PlaceCategory? {
        return allCategories.first { $0.id == id }
    }
    
    /// Get category by ID with fallback
    static func categoryOrDefault(for id: String) -> PlaceCategory {
        return category(for: id) ?? unknownCategory
    }
    
    /// Default category for unknown types
    static let unknownCategory = PlaceCategory(
        id: "unknown",
        displayName: "Unknown",
        icon: "mappin",
        color: .grey100,
        priority: 999
    )
    

    
    // MARK: - Category Filtering
    
    /// Get categories sorted by priority
    static var categoriesByPriority: [PlaceCategory] {
        return allCategories.sorted { $0.priority < $1.priority }
    }
    
    /// Get categories for display (excluding unknown)
    static var displayCategories: [PlaceCategory] {
        return allCategories.filter { $0.id != "unknown" }
    }
    
    // MARK: - Search Keywords
    
    /// Common search keywords mapped to category IDs
    static let searchKeywords: [String: [String]] = [
        "coffee": ["coffee_shop"],
        "restaurant": ["restaurant"],
        "food": ["restaurant"],
        "eat": ["restaurant"],
        "dining": ["restaurant"],
        "park": ["park"],
        "garden": ["park"],
        "outdoor": ["park"],
        "museum": ["museum"],
        "art": ["museum"],
        "gallery": ["museum"],
        "shopping": ["shopping"],
        "store": ["shopping"],
        "mall": ["shopping"],
        "hotel": ["hotel"],
        "accommodation": ["hotel"],
        "stay": ["hotel"],
        "lodge": ["hotel"]
    ]
    
    /// Get categories that match a search keyword
    static func categories(for keyword: String) -> [PlaceCategory] {
        let lowercaseKeyword = keyword.lowercased()
        let categoryIds = searchKeywords[lowercaseKeyword] ?? []
        return categoryIds.compactMap { category(for: $0) }
    }
    
    // MARK: - Provider Mapping
    
    /// Map provider-specific types to our categories
    /// This will be useful when integrating with Google Places, Foursquare, etc.
    static func mapProviderType(_ providerType: String, provider: String = "google") -> PlaceCategory {
        switch provider.lowercased() {
        case "google":
            return mapGoogleType(providerType)
        default:
            return unknownCategory
        }
    }
    
    /// Map Google Places types to our categories
    private static func mapGoogleType(_ googleType: String) -> PlaceCategory {
        switch googleType.lowercased() {
        case "restaurant", "food", "meal_delivery", "meal_takeaway":
            return categoryOrDefault(for: "restaurant")
        case "cafe", "coffee_shop":
            return categoryOrDefault(for: "coffee_shop")
        case "park", "campground", "rv_park":
            return categoryOrDefault(for: "park")
        case "museum", "art_gallery", "zoo", "aquarium":
            return categoryOrDefault(for: "museum")
        case "shopping_mall", "department_store", "clothing_store", "store":
            return categoryOrDefault(for: "shopping")
        case "lodging", "hotel", "motel":
            return categoryOrDefault(for: "hotel")
        default:
            return unknownCategory
        }
    }
}

// MARK: - SwiftUI Preview

#Preview("Category Registry Overview") {
    VStack(spacing: 0) {
        Text("Category Registry")
            .font(.title2)
            .fontWeight(.bold)
            .padding()
        
        VStack(spacing: 0) {
            ForEach(CategoryRegistry.allCategories, id: \.id) { category in
                ListItem(
                    artwork: .circleIcon(
                        color: category.color,
                        icon: Image(systemName: category.icon)
                    ),
                    title: category.displayName,
                    subtitle: category.id,
                    thirdText: "Priority: \(category.priority)"
                )
            }
            
            // Unknown category
            ListItem(
                artwork: .circleIcon(
                    color: CategoryRegistry.unknownCategory.color,
                    icon: Image(systemName: CategoryRegistry.unknownCategory.icon)
                ),
                title: CategoryRegistry.unknownCategory.displayName,
                subtitle: CategoryRegistry.unknownCategory.id,
                thirdText: "Priority: \(CategoryRegistry.unknownCategory.priority)"
            )
        }
        
        Spacer()
    }
    .background(Color(.systemGroupedBackground))
} 
