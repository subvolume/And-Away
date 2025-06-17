//
//  MockPlacesData.swift
//  And Away
//
//  Mock data service for testing our foundation models
//

import Foundation
import CoreLocation

// MARK: - Mock Places Data Service

struct MockPlacesData {
    
    // MARK: - Sample Categories (using CategoryRegistry)
    
    static let sampleCategories: [PlaceCategory] = CategoryRegistry.allCategories
    
    // MARK: - Sample Photos
    
    static func createSamplePhotos(for placeId: String) -> [PlaceImageInfo] {
        return [
            PlaceImageInfo(
                id: "\(placeId)_photo_1",
                url: URL(string: "https://example.com/\(placeId)_1.jpg")!,
                width: 1200,
                height: 800,
                attributions: ["© Business Owner"]
            ),
            PlaceImageInfo(
                id: "\(placeId)_photo_2",
                url: URL(string: "https://example.com/\(placeId)_2.jpg")!,
                width: 800,
                height: 600,
                attributions: ["© Customer Photo"]
            )
        ]
    }
    
    // MARK: - Sample Places (San Francisco Area)
    
    static let samplePlaces: [Place] = [
        
        // Coffee Shops
        Place(
            id: "bluebottle_sf_001",
            name: "Blue Bottle Coffee",
            latitude: 37.7749,
            longitude: -122.4194,
            locality: "San Francisco",
            category: sampleCategories[1], // Coffee Shop
            isOpen: .openUntil(Date().addingTimeInterval(3600)),
            photos: createSamplePhotos(for: "bluebottle"),
            distanceFromUser: 125.0,
            address: "315 Linden St, San Francisco, CA 94102",
            phoneNumber: "+1 510-653-3394",
            website: URL(string: "https://bluebottlecoffee.com"),
            googleMapsLink: URL(string: "https://maps.google.com/?cid=123456789"),
            tripadvisorLink: URL(string: "https://tripadvisor.com/bluebottle")
        ),
        
        Place(
            id: "philz_sf_001",
            name: "Philz Coffee",
            latitude: 37.7849,
            longitude: -122.4094,
            locality: "San Francisco",
            category: sampleCategories[1], // Coffee Shop
            isOpen: .open,
            photos: createSamplePhotos(for: "philz"),
            distanceFromUser: 350.0,
            address: "3101 24th St, San Francisco, CA 94110",
            phoneNumber: "+1 415-875-9943",
            website: URL(string: "https://philzcoffee.com"),
            googleMapsLink: URL(string: "https://maps.google.com/?cid=987654321"),
            tripadvisorLink: nil
        ),
        
        // Restaurants
        Place(
            id: "tartine_sf_001",
            name: "Tartine Bakery",
            latitude: 37.7649,
            longitude: -122.4294,
            locality: "San Francisco",
            category: sampleCategories[0], // Restaurant
            isOpen: .opensAt(Date().addingTimeInterval(7200)),
            photos: createSamplePhotos(for: "tartine"),
            distanceFromUser: 875.0,
            address: "600 Guerrero St, San Francisco, CA 94110",
            phoneNumber: "+1 415-487-2600",
            website: URL(string: "https://tartinebakery.com"),
            googleMapsLink: URL(string: "https://maps.google.com/?cid=456789123"),
            tripadvisorLink: URL(string: "https://tripadvisor.com/tartine")
        ),
        
        Place(
            id: "zuni_sf_001",
            name: "Zuni Café",
            latitude: 37.7749,
            longitude: -122.4294,
            locality: "San Francisco",
            category: sampleCategories[0], // Restaurant
            isOpen: .closed,
            photos: createSamplePhotos(for: "zuni"),
            distanceFromUser: 650.0,
            address: "1658 Market St, San Francisco, CA 94102",
            phoneNumber: "+1 415-552-2522",
            website: URL(string: "https://zunicafe.com"),
            googleMapsLink: URL(string: "https://maps.google.com/?cid=789123456"),
            tripadvisorLink: URL(string: "https://tripadvisor.com/zuni")
        ),
        
        // Parks
        Place(
            id: "golden_gate_park",
            name: "Golden Gate Park",
            latitude: 37.7694,
            longitude: -122.4862,
            locality: "San Francisco",
            category: sampleCategories[2], // Park
            isOpen: .open,
            photos: createSamplePhotos(for: "ggpark"),
            distanceFromUser: 2100.0,
            address: "Golden Gate Park, San Francisco, CA",
            phoneNumber: "+1 415-831-2700",
            website: URL(string: "https://sfrecpark.org/facilities/golden-gate-park/"),
            googleMapsLink: URL(string: "https://maps.google.com/?cid=321654987"),
            tripadvisorLink: URL(string: "https://tripadvisor.com/golden-gate-park")
        ),
        
        Place(
            id: "dolores_park",
            name: "Dolores Park",
            latitude: 37.7596,
            longitude: -122.4269,
            locality: "San Francisco",
            category: sampleCategories[2], // Park
            isOpen: .open,
            photos: createSamplePhotos(for: "dolores"),
            distanceFromUser: 980.0,
            address: "Dolores St & 18th St, San Francisco, CA 94114",
            phoneNumber: "+1 415-831-2700",
            website: URL(string: "https://sfrecpark.org/facilities/dolores-park/"),
            googleMapsLink: URL(string: "https://maps.google.com/?cid=654987321"),
            tripadvisorLink: URL(string: "https://tripadvisor.com/dolores-park")
        ),
        
        // Museums
        Place(
            id: "sfmoma_001",
            name: "San Francisco Museum of Modern Art",
            latitude: 37.7857,
            longitude: -122.4011,
            locality: "San Francisco",
            category: sampleCategories[3], // Museum
            isOpen: .openUntil(Date().addingTimeInterval(7200)),
            photos: createSamplePhotos(for: "sfmoma"),
            distanceFromUser: 1200.0,
            address: "151 3rd St, San Francisco, CA 94103",
            phoneNumber: "+1 415-357-4000",
            website: URL(string: "https://www.sfmoma.org"),
            googleMapsLink: URL(string: "https://maps.google.com/?cid=147258369"),
            tripadvisorLink: URL(string: "https://tripadvisor.com/sfmoma")
        ),
        
        // Shopping
        Place(
            id: "union_square_001",
            name: "Union Square",
            latitude: 37.7880,
            longitude: -122.4074,
            locality: "San Francisco",
            category: sampleCategories[4], // Shopping
            isOpen: .open,
            photos: createSamplePhotos(for: "union"),
            distanceFromUser: 1800.0,
            address: "333 Post St, San Francisco, CA 94108",
            phoneNumber: nil,
            website: URL(string: "https://visitunionsquaresf.com"),
            googleMapsLink: URL(string: "https://maps.google.com/?cid=369147258"),
            tripadvisorLink: URL(string: "https://tripadvisor.com/union-square")
        ),
        
        // Hotels
        Place(
            id: "st_regis_sf_001",
            name: "The St. Regis San Francisco",
            latitude: 37.7854,
            longitude: -122.4056,
            locality: "San Francisco",
            category: sampleCategories[5], // Hotel
            isOpen: .open,
            photos: createSamplePhotos(for: "stregis"),
            distanceFromUser: 1350.0,
            address: "125 3rd St, San Francisco, CA 94103",
            phoneNumber: "+1 415-284-4000",
            website: URL(string: "https://marriott.com/stregis-sf"),
            googleMapsLink: URL(string: "https://maps.google.com/?cid=258369147"),
            tripadvisorLink: URL(string: "https://tripadvisor.com/st-regis-sf")
        )
    ]
    
    // MARK: - Mock Search Context
    
    static let mockSearchContext = SearchContext(
        userLocation: CLLocation(latitude: 37.7749, longitude: -122.4194), // SF coordinates
        searchOrigin: CLLocation(latitude: 37.7749, longitude: -122.4194),
        searchRadius: 2000.0, // 2km radius
        locationAccuracy: 5.0,
        isLocationRecent: true
    )
    
    // MARK: - Create Mock Search Results
    
    static func createMockSearchResults(query: String = "") -> OrganizedSearchResults {
        
        // Create search results with different match types
        let searchResults = samplePlaces.enumerated().map { index, place in
            
            let matchType: SearchMatchType
            let relevanceScore: Double
            
            // Simulate different match types based on place name
            if place.name.lowercased().contains(query.lowercased()) && !query.isEmpty {
                matchType = query.lowercased() == place.name.lowercased() ? .exactNameMatch : .partialNameMatch
                relevanceScore = matchType == .exactNameMatch ? 0.98 : 0.85
            } else if index < 2 { // First two are "saved places"
                matchType = .savedPlace
                relevanceScore = 1.0
            } else if place.category.id == "coffee_shop" && query.lowercased().contains("coffee") {
                matchType = .categoryMatch
                relevanceScore = 0.75
            } else if place.distanceFromUser ?? 1000 < 500 {
                matchType = .nearbyDiscovery
                relevanceScore = 0.70
            } else {
                matchType = .globalSearch
                relevanceScore = 0.60
            }
            
            return SearchResult(
                place: place,
                matchType: matchType,
                relevanceScore: relevanceScore,
                distanceFromUser: place.distanceFromUser,
                searchContext: mockSearchContext
            )
        }
        
        // Organize results by type
        let exactMatches = searchResults.filter { $0.matchType == SearchMatchType.exactNameMatch }
        let savedPlaces = searchResults.filter { $0.matchType == SearchMatchType.savedPlace }
        let categoryMatches = searchResults.filter { $0.matchType == SearchMatchType.categoryMatch }
        let nearbyResults = searchResults.filter { $0.matchType == SearchMatchType.nearbyDiscovery }
        let extendedResults = searchResults.filter { $0.matchType == SearchMatchType.globalSearch }
        
        return OrganizedSearchResults(
            exactMatches: exactMatches,
            savedPlaces: savedPlaces,
            nearbyResults: nearbyResults,
            categoryMatches: categoryMatches,
            extendedResults: extendedResults,
            searchContext: mockSearchContext
        )
    }
    
    // MARK: - Convenience Methods
    
    /// Get places by category
    static func places(in category: PlaceCategory) -> [Place] {
        return samplePlaces.filter { $0.category.id == category.id }
    }
    
    /// Get nearby places (within distance)
    static func nearbyPlaces(within meters: Double) -> [Place] {
        return samplePlaces.filter { ($0.distanceFromUser ?? Double.infinity) <= meters }
    }
    
    /// Get currently open places
    static var openPlaces: [Place] {
        return samplePlaces.filter { $0.isOpen?.isCurrentlyOpen == true }
    }
    
    /// Get places with photos
    static var placesWithPhotos: [Place] {
        return samplePlaces.filter { $0.hasPhotos }
    }
    
    /// Search places by name
    static func searchPlaces(query: String) -> [Place] {
        guard !query.isEmpty else { return samplePlaces }
        return samplePlaces.filter { 
            $0.name.lowercased().contains(query.lowercased()) ||
            $0.category.displayName.lowercased().contains(query.lowercased()) ||
            $0.address.lowercased().contains(query.lowercased())
        }
    }
} 