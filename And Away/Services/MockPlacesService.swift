//
//  MockPlacesService.swift
//  And Away
//
//  Mock implementation of PlacesSearchService for testing
//

import Foundation
import CoreLocation

// MARK: - Mock Places Service

class MockPlacesService: PlacesSearchService {
    
    // MARK: - PlacesSearchService Implementation
    
    /// Search for places using text query
    func searchPlaces(
        query: String,
        location: CLLocation?,
        radius: Double?
    ) async throws -> OrganizedSearchResults {
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
        
        let searchRadius = radius ?? 2000.0 // Default 2km
        let userLocation = location ?? MockPlacesData.mockSearchContext.userLocation
        
        // Create search context
        let searchContext = SearchContext(
            userLocation: userLocation,
            searchOrigin: userLocation,
            searchRadius: searchRadius,
            locationAccuracy: 5.0,
            isLocationRecent: true
        )
        
        // Get all places and create search results
        var allResults: [SearchResult] = []
        
        for place in MockPlacesData.samplePlaces {
            
            // Calculate distance if user location available
            let distanceFromUser: Double?
            if let userLoc = userLocation {
                distanceFromUser = userLoc.distance(from: place.location)
            } else {
                distanceFromUser = place.distanceFromUser
            }
            
            // Skip places outside radius if specified
            if let distance = distanceFromUser, distance > searchRadius {
                continue
            }
            
            // Determine match type and relevance
            let (matchType, relevanceScore) = calculateMatchTypeAndScore(
                place: place,
                query: query,
                distance: distanceFromUser
            )
            
            // Only include if it's a relevant match
            if matchType != nil {
                let searchResult = SearchResult(
                    place: place,
                    matchType: matchType!,
                    relevanceScore: relevanceScore,
                    distanceFromUser: distanceFromUser,
                    searchContext: searchContext
                )
                allResults.append(searchResult)
            }
        }
        
        // Sort by display priority (match type + relevance)
        allResults.sort { $0.displayPriority < $1.displayPriority }
        
        // Organize results by type
        return OrganizedSearchResults(
            exactMatches: allResults.filter { $0.matchType == .exactNameMatch || $0.matchType == .partialNameMatch },
            savedPlaces: allResults.filter { $0.matchType == .savedPlace },
            nearbyResults: allResults.filter { $0.matchType == .nearbyDiscovery },
            categoryMatches: allResults.filter { $0.matchType == .categoryMatch },
            extendedResults: allResults.filter { $0.matchType == .globalSearch },
            searchContext: searchContext
        )
    }
    
    /// Search for nearby places within a specific category
    func nearbyPlaces(
        category: PlaceCategory?,
        location: CLLocation,
        radius: Double
    ) async throws -> [Place] {
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        
        var filteredPlaces = MockPlacesData.samplePlaces
        
        // Filter by category if specified
        if let category = category {
            filteredPlaces = filteredPlaces.filter { $0.category.id == category.id }
        }
        
        // Filter by distance and sort by proximity
        let nearbyPlaces = filteredPlaces.compactMap { place -> (Place, Double)? in
            let distance = location.distance(from: place.location)
            return distance <= radius ? (place, distance) : nil
        }
        .sorted { $0.1 < $1.1 } // Sort by distance
        .map { $0.0 } // Extract places
        
        return nearbyPlaces
    }
    
    /// Search for places by name with autocomplete-style results
    func searchByName(
        partialName: String,
        location: CLLocation?
    ) async throws -> [Place] {
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 150_000_000) // 0.15 seconds
        
        guard !partialName.isEmpty else {
            return []
        }
        
        let query = partialName.lowercased()
        
        // Find places that match the partial name
        let matchingPlaces = MockPlacesData.samplePlaces.filter { place in
            place.name.lowercased().contains(query)
        }
        
        // Sort by relevance (exact matches first, then by distance if location available)
        let sortedPlaces = matchingPlaces.sorted { place1, place2 in
            let name1 = place1.name.lowercased()
            let name2 = place2.name.lowercased()
            
            // Exact matches first
            let exact1 = name1 == query
            let exact2 = name2 == query
            if exact1 != exact2 {
                return exact1
            }
            
            // Then by starts with
            let starts1 = name1.hasPrefix(query)
            let starts2 = name2.hasPrefix(query)
            if starts1 != starts2 {
                return starts1
            }
            
            // Finally by distance if available
            if let userLocation = location {
                let dist1 = userLocation.distance(from: place1.location)
                let dist2 = userLocation.distance(from: place2.location)
                return dist1 < dist2
            }
            
            return place1.name < place2.name
        }
        
        return Array(sortedPlaces.prefix(10)) // Limit to 10 results for autocomplete
    }
    
    // MARK: - Private Helper Methods
    
    /// Calculate match type and relevance score for a place given a search query
    private func calculateMatchTypeAndScore(
        place: Place,
        query: String,
        distance: Double?
    ) -> (SearchMatchType?, Double) {
        
        let queryLower = query.lowercased().trimmingCharacters(in: .whitespaces)
        
        // Empty query - show nearby discovery
        if queryLower.isEmpty {
            if let dist = distance, dist < 500 {
                return (.nearbyDiscovery, 0.70)
            } else {
                return (.globalSearch, 0.50)
            }
        }
        
        let placeName = place.name.lowercased()
        let categoryName = place.category.displayName.lowercased()
        let address = place.address.lowercased()
        

        
        // Exact name match
        if placeName == queryLower {
            return (.exactNameMatch, 0.98)
        }
        
        // Partial name match
        if placeName.contains(queryLower) {
            let score = queryLower.count == placeName.count ? 0.95 : 0.85
            return (.partialNameMatch, score)
        }
        
        // Check for common category keywords using CategoryRegistry
        for (keyword, categoryIds) in CategoryRegistry.searchKeywords {
            if queryLower.contains(keyword) && categoryIds.contains(place.category.id) {
                let baseScore = 0.70
                let distanceBoost = (distance ?? 1000) < 500 ? 0.1 : 0.0
                return (.categoryMatch, baseScore + distanceBoost)
            }
        }
        
        // Generic category match
        if categoryName.contains(queryLower) || queryLower.contains(categoryName) {
            let baseScore = 0.75
            // Boost score if nearby
            let distanceBoost = (distance ?? 1000) < 500 ? 0.1 : 0.0
            return (.categoryMatch, baseScore + distanceBoost)
        }
        
        // Address match
        if address.contains(queryLower) {
            return (.globalSearch, 0.60)
        }
        
        // Word-based matching
        let placeWords = placeName.components(separatedBy: .whitespaces)
        for word in placeWords {
            if word.hasPrefix(queryLower) {
                return (.partialNameMatch, 0.80)
            }
        }
        
        // No relevant match
        return (nil, 0.0)
    }
}

// MARK: - Convenience Extensions

extension MockPlacesService {
    
    /// Quick search for testing - returns first few results
    func quickSearch(_ query: String) async throws -> [Place] {
        let results = try await searchPlaces(query: query, location: nil, radius: nil)
        return Array(results.allResults.prefix(5).map { $0.place })
    }
    
    /// Get sample places for testing
    func getSamplePlaces() -> [Place] {
        return MockPlacesData.samplePlaces
    }
} 