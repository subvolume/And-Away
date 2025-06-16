//
//  FoundationDemo.swift
//  And Away
//
//  Demonstration of how our foundation models work
//

import Foundation
import CoreLocation

// MARK: - Foundation Demo

struct FoundationDemo {
    
    /// Demonstrates creating and using our core models
    static func demonstrateFoundation() {
        print("🏗️ And Away Foundation Demo")
        print("==========================================")
        
        // Create sample data
        let (place, searchResult) = createSampleData()
        
        // Demonstrate Place model
        demonstratePlace(place)
        
        // Demonstrate SearchResult model
        demonstrateSearchResult(searchResult)
        
        // Demonstrate organized results
        demonstrateOrganizedResults(searchResult)
        
        print("\n✅ Foundation demo complete!")
    }
    
    // MARK: - Create Sample Data
    
    static func createSampleData() -> (Place, SearchResult) {
        
        // 1. Create PlaceCategory
        let coffeeCategory = PlaceCategory(
            id: "coffee_shop",
            displayName: "Coffee Shop",
            icon: "cup.and.saucer",
            color: "brown",
            priority: 1
        )
        
        // 2. Create PlaceImageInfo
        let photo1 = PlaceImageInfo(
            id: "photo_1",
            url: URL(string: "https://example.com/bluebottle1.jpg")!,
            width: 800,
            height: 600,
            attributions: ["© Blue Bottle Coffee"]
        )
        
        let photo2 = PlaceImageInfo(
            id: "photo_2", 
            url: URL(string: "https://example.com/bluebottle2.jpg")!,
            width: 1200,
            height: 800,
            attributions: ["© Customer Photo"]
        )
        
        // 3. Create Place with OpenStatus
        let place = Place(
            id: "bluebottle_sf_123",
            name: "Blue Bottle Coffee",
            latitude: 37.7749,
            longitude: -122.4194,
            locality: "San Francisco",
            category: coffeeCategory,
            isOpen: .openUntil(Date().addingTimeInterval(3600)), // Open for 1 more hour
            photos: [photo1, photo2],
            distanceFromUser: 125.0,
            address: "123 Main St, San Francisco, CA 94102",
            phoneNumber: "+1-555-COFFEE",
            website: URL(string: "https://bluebottlecoffee.com"),
            googleMapsLink: URL(string: "https://maps.google.com/?q=Blue+Bottle+Coffee"),
            tripadvisorLink: URL(string: "https://tripadvisor.com/bluebottle")
        )
        
        // 4. Create SearchContext
        let userLocation = CLLocation(latitude: 37.7750, longitude: -122.4195)
        let searchContext = SearchContext(
            userLocation: userLocation,
            searchOrigin: userLocation,
            searchRadius: 1000,
            locationAccuracy: 5.0,
            isLocationRecent: true
        )
        
        // 5. Create SearchResult
        let searchResult = SearchResult(
            place: place,
            matchType: .partialNameMatch,
            relevanceScore: 0.92,
            distanceFromUser: 125.0,
            searchContext: searchContext
        )
        
        return (place, searchResult)
    }
    
    // MARK: - Demonstrations
    
    static func demonstratePlace(_ place: Place) {
        print("\n📍 Place Model Demo:")
        print("   Name: \(place.name)")
        print("   Category: \(place.category.displayName) (\(place.category.icon))")
        print("   Location: \(place.location.coordinate.latitude), \(place.location.coordinate.longitude)")
        print("   Distance: \(place.formattedDistance ?? "unknown")")
        print("   Address: \(place.address)")
        print("   Open Status: \(place.isOpen?.description ?? "unknown")")
        print("   Is Currently Open: \(place.isOpen?.isCurrentlyOpen ?? false)")
        print("   Has Photos: \(place.hasPhotos) (\(place.photos.count) photos)")
        print("   Primary Photo: \(place.primaryPhoto?.id ?? "none")")
        print("   Phone: \(place.phoneNumber ?? "none")")
        print("   Website: \(place.website?.absoluteString ?? "none")")
    }
    
    static func demonstrateSearchResult(_ searchResult: SearchResult) {
        print("\n🔍 SearchResult Model Demo:")
        print("   Match Type: \(searchResult.matchType.description)")
        print("   Priority: \(searchResult.matchType.priority)")
        print("   Relevance Score: \(searchResult.formattedRelevanceScore)")
        print("   High Quality: \(searchResult.isHighQuality)")
        print("   Display Priority: \(String(format: "%.2f", searchResult.displayPriority))")
        
        let context = searchResult.searchContext
        print("   Search Context:")
        print("     - Radius: \(context.formattedRadius)")
        print("     - Good Location: \(context.hasGoodLocationContext)")
        print("     - Accuracy: \(context.locationAccuracy)m")
        print("     - Recent: \(context.isLocationRecent)")
    }
    
    static func demonstrateOrganizedResults(_ searchResult: SearchResult) {
        print("\n📋 OrganizedSearchResults Demo:")
        
        // Create different types of results for demonstration
        let exactMatch = SearchResult(
            place: searchResult.place,
            matchType: .exactNameMatch,
            relevanceScore: 0.98,
            distanceFromUser: 50,
            searchContext: searchResult.searchContext
        )
        
        let savedPlace = SearchResult(
            place: searchResult.place,
            matchType: .savedPlace,
            relevanceScore: 1.0,
            distanceFromUser: 200,
            searchContext: searchResult.searchContext
        )
        
        let organizedResults = OrganizedSearchResults(
            exactMatches: [exactMatch],
            savedPlaces: [savedPlace],
            nearbyResults: [searchResult],
            categoryMatches: [],
            extendedResults: [],
            searchContext: searchResult.searchContext
        )
        
        print("   Total Results: \(organizedResults.totalCount)")
        print("   Has Results: \(organizedResults.hasResults)")
        print("   Exact Matches: \(organizedResults.exactMatches.count)")
        print("   Saved Places: \(organizedResults.savedPlaces.count)")
        print("   Nearby Results: \(organizedResults.nearbyResults.count)")
        print("   All Results Count: \(organizedResults.allResults.count)")
    }
}

// MARK: - Different Status Examples

extension FoundationDemo {
    
    /// Shows different OpenStatus examples
    static func demonstrateOpenStatus() {
        print("\n🕐 OpenStatus Examples:")
        
        let statuses: [OpenStatus] = [
            .open,
            .closed,
            .unknown,
            .openUntil(Date().addingTimeInterval(3600)), // 1 hour from now
            .opensAt(Date().addingTimeInterval(7200))    // 2 hours from now
        ]
        
        for status in statuses {
            print("   \(status.description) (Currently Open: \(status.isCurrentlyOpen))")
        }
    }
    
    /// Shows different SearchMatchType examples
    static func demonstrateMatchTypes() {
        print("\n🎯 SearchMatchType Examples:")
        
        for matchType in SearchMatchType.allCases {
            print("   \(matchType.description) (Priority: \(matchType.priority))")
        }
    }
}

// MARK: - Call Demo

extension FoundationDemo {
    /// Easy way to run the full demonstration
    static func runFullDemo() {
        demonstrateFoundation()
        demonstrateOpenStatus()
        demonstrateMatchTypes()
    }
}

// MARK: - Quick Demo Runner
// To run this demo, call FoundationDemo.runFullDemo() from anywhere in your app 
