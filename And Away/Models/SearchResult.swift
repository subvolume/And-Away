//
//  SearchResult.swift
//  And Away
//
//  Search result models with scoring and context
//

import Foundation
import CoreLocation

// MARK: - Search Result Models

/// Wrapper for search results with context and relevance scoring
struct SearchResult: Identifiable {
    let id = UUID()
    let place: Place                        // The actual place
    let matchType: SearchMatchType          // How this result matched
    let relevanceScore: Double              // Calculated relevance (0-1)
    let distanceFromUser: Double?           // Distance in meters
    let searchContext: SearchContext        // Location context
}

/// How a search result matched the query
enum SearchMatchType: CaseIterable {
    case exactNameMatch                     // "Starbucks" → "Starbucks Coffee"
    case partialNameMatch                   // "coffee" → "Blue Bottle Coffee"
    case categoryMatch                      // "restaurant" → restaurants near user
    case savedPlace                         // User's bookmarked places
    case nearbyDiscovery                    // New places near user location
    case globalSearch                       // Results outside user's immediate area
    
    var priority: Int {
        switch self {
        case .exactNameMatch: return 1
        case .savedPlace: return 2
        case .partialNameMatch: return 3
        case .categoryMatch: return 4
        case .nearbyDiscovery: return 5
        case .globalSearch: return 6
        }
    }
    
    var description: String {
        switch self {
        case .exactNameMatch: return "Exact match"
        case .partialNameMatch: return "Name contains"
        case .categoryMatch: return "Category match"
        case .savedPlace: return "Your saved place"
        case .nearbyDiscovery: return "Nearby"
        case .globalSearch: return "Global search"
        }
    }
}

/// Context information for a search
struct SearchContext {
    let userLocation: CLLocation?           // User's current position
    let searchOrigin: CLLocation?           // Where the search is centered
    let searchRadius: Double                // Effective search radius
    let locationAccuracy: CLLocationAccuracy // GPS accuracy
    let isLocationRecent: Bool              // Is location data fresh
}

/// Search query parameters
struct SearchQuery {
    let text: String?                       // User's search text
    let categories: [PlaceCategory]         // Filtered categories
    let location: CLLocation?               // Search center point
    let maxDistance: Double?                // Search radius
}

/// Organized search results by type
struct OrganizedSearchResults {
    let exactMatches: [SearchResult]        // Perfect name matches
    let savedPlaces: [SearchResult]         // User's bookmarks that match
    let nearbyResults: [SearchResult]       // Results within close radius
    let categoryMatches: [SearchResult]     // Category-based matches
    let extendedResults: [SearchResult]     // Results from wider search
    let searchContext: SearchContext        // Context for this search
    
    /// All results flattened in priority order
    var allResults: [SearchResult] {
        var combined: [SearchResult] = []
        combined.append(contentsOf: exactMatches)
        combined.append(contentsOf: savedPlaces)
        combined.append(contentsOf: nearbyResults)
        combined.append(contentsOf: categoryMatches)
        combined.append(contentsOf: extendedResults)
        return combined
    }
    
    /// Total number of results
    var totalCount: Int {
        exactMatches.count + savedPlaces.count + nearbyResults.count + 
        categoryMatches.count + extendedResults.count
    }
    
    /// Whether we have any results
    var hasResults: Bool {
        totalCount > 0
    }
}

// MARK: - Search Result Extensions

extension SearchResult {
    /// Formatted relevance score for debugging
    var formattedRelevanceScore: String {
        String(format: "%.2f", relevanceScore)
    }
    
    /// Whether this is a high-quality result
    var isHighQuality: Bool {
        relevanceScore > 0.7
    }
    
    /// Combined display priority (match type + relevance)
    var displayPriority: Double {
        // Lower is better - match type priority + inverse relevance
        Double(matchType.priority) + (1.0 - relevanceScore)
    }
}

extension SearchContext {
    /// Whether the search has good location context
    var hasGoodLocationContext: Bool {
        guard let userLocation = userLocation else { return false }
        return isLocationRecent && locationAccuracy < 100 // Within 100m accuracy
    }
    
    /// Formatted search radius for display
    var formattedRadius: String {
        if searchRadius < 1000 {
            return "\(Int(searchRadius))m"
        } else {
            let km = searchRadius / 1000
            return String(format: "%.1fkm", km)
        }
    }
} 