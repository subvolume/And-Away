//
//  AppleMapKitService.swift
//  And Away
//
//  Apple MapKit implementation of PlacesSearchService
//

import Foundation
import CoreLocation
import MapKit

// MARK: - Apple MapKit Service

class AppleMapKitService: PlacesSearchService {
    
    // MARK: - PlacesSearchService Implementation
    
    /// Search for places using text query with Apple MapKit
    func searchPlaces(
        query: String,
        location: CLLocation?,
        radius: Double?
    ) async throws -> OrganizedSearchResults {
        
        // Create MKLocalSearchRequest
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        // Set search region if location is provided
        if let location = location {
            let searchRadius = radius ?? 1000.0
            let region = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: searchRadius * 2,
                longitudinalMeters: searchRadius * 2
            )
            request.region = region
        }
        
        // Perform search
        let search = MKLocalSearch(request: request)
        let response = try await search.start()
        
        // Convert results to our Place model
        let places = response.mapItems.compactMap { mapItem in
            convertToPlace(mapItem, userLocation: location)
        }
        
        // Create search context
        let searchContext = SearchContext(
            userLocation: location,
            searchOrigin: location,
            searchRadius: radius ?? 1000.0,
            locationAccuracy: location?.horizontalAccuracy ?? 10.0,
            isLocationRecent: true
        )
        
        // Organize results using existing logic (simplified for now)
        let exactMatches = places.filter { place in
            place.name.lowercased().contains(query.lowercased())
        }
        
        let categoryMatches = places.filter { place in
            CategoryRegistry.searchKeywords.contains { (keyword, categoryIds) in
                query.lowercased().contains(keyword.lowercased()) && 
                categoryIds.contains(place.category.id)
            }
        }
        
        let remainingPlaces = places.filter { place in
            !exactMatches.contains(where: { $0.id == place.id }) &&
            !categoryMatches.contains(where: { $0.id == place.id })
        }
        
        return OrganizedSearchResults(
            exactMatches: exactMatches.map { place in
                SearchResult(
                    place: place,
                    matchType: .exactNameMatch,
                    relevanceScore: 0.9,
                    distanceFromUser: place.distanceFromUser,
                    searchContext: searchContext
                )
            },
            savedPlaces: [], // TODO: Implement saved places lookup
            nearbyResults: remainingPlaces.map { place in
                SearchResult(
                    place: place,
                    matchType: .nearbyDiscovery,
                    relevanceScore: 0.6,
                    distanceFromUser: place.distanceFromUser,
                    searchContext: searchContext
                )
            },
            categoryMatches: categoryMatches.map { place in
                SearchResult(
                    place: place,
                    matchType: .categoryMatch,
                    relevanceScore: 0.7,
                    distanceFromUser: place.distanceFromUser,
                    searchContext: searchContext
                )
            },
            extendedResults: [],
            searchContext: searchContext
        )
    }
    
    /// Search for nearby places within a specific category using Apple MapKit
    func nearbyPlaces(
        category: PlaceCategory?,
        location: CLLocation,
        radius: Double
    ) async throws -> [Place] {
        
        // TODO: Implement MKLocalSearch with category filters
        // For now, return empty array to make it compile
        
        return []
    }
    
    /// Search for places by name with Apple MapKit autocomplete-style results
    func searchByName(
        partialName: String,
        location: CLLocation?
    ) async throws -> [Place] {
        
        // TODO: Implement MKLocalSearch for name-based search
        // For now, return empty array to make it compile
        
        return []
    }
}

// MARK: - Private Helper Methods

private extension AppleMapKitService {
    
    /// Convert MKMapItem to our Place model
    func convertToPlace(_ mapItem: MKMapItem, userLocation: CLLocation?) -> Place? {
        let placemark = mapItem.placemark
        
        // Generate unique ID
        let placeId = "apple_\(abs(placemark.coordinate.latitude.hashValue ^ placemark.coordinate.longitude.hashValue))"
        
        // Extract basic information
        let name = mapItem.name ?? placemark.name ?? "Unknown Place"
        let coordinate = placemark.coordinate
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        // Build address
        let address = buildAddress(from: placemark)
        
        // Calculate distance if user location is provided
        let distanceFromUser = userLocation?.distance(from: location)
        
        // Map to our category system
        let category = mapAppleCategory(mapItem)
        
        // Extract phone number if available
        let phoneNumber = mapItem.phoneNumber
        
        // Extract locality (city/area name)
        let locality = placemark.locality ?? placemark.administrativeArea ?? "Unknown"
        
        // Create Place object
        return Place(
            id: placeId,
            name: name,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            locality: locality,
            category: category,
            isOpen: .unknown, // Apple MapKit doesn't provide open status easily
            photos: [], // Apple MapKit doesn't provide photos
            distanceFromUser: distanceFromUser,
            address: address,
            phoneNumber: phoneNumber,
            website: mapItem.url,
            googleMapsLink: nil, // Could build this later
            tripadvisorLink: nil // Not available from Apple MapKit
        )
    }
    
    /// Map Apple category types to our CategoryRegistry
    func mapAppleCategory(_ mapItem: MKMapItem) -> PlaceCategory {
        // Apple MapKit doesn't provide rich category information like Google Places
        // We'll use basic heuristics based on name and available data
        
        let name = mapItem.name?.lowercased() ?? ""
        
        // Check for food/dining keywords
        if name.contains("restaurant") || name.contains("cafe") || name.contains("coffee") || 
           name.contains("bar") || name.contains("pizza") || name.contains("burger") ||
           name.contains("deli") || name.contains("bakery") || name.contains("bistro") {
            return CategoryRegistry.categoryOrDefault(for: "restaurant")
        }
        
        // Check for coffee shop keywords
        if name.contains("coffee") || name.contains("cafe") || name.contains("espresso") {
            return CategoryRegistry.categoryOrDefault(for: "coffee_shop")
        }
        
        // Check for shopping keywords
        if name.contains("store") || name.contains("shop") || name.contains("mall") ||
           name.contains("market") || name.contains("boutique") || name.contains("retail") {
            return CategoryRegistry.categoryOrDefault(for: "shopping")
        }
        
        // Check for museum/entertainment keywords
        if name.contains("theater") || name.contains("cinema") || name.contains("museum") ||
           name.contains("gallery") || name.contains("club") || name.contains("venue") || name.contains("stadium") {
            return CategoryRegistry.categoryOrDefault(for: "museum")
        }
        
        // Check for park keywords
        if name.contains("park") || name.contains("trail") || name.contains("beach") ||
           name.contains("outdoor") || name.contains("nature") || name.contains("recreation") {
            return CategoryRegistry.categoryOrDefault(for: "park")
        }
        
        // Check for hotel keywords
        if name.contains("hotel") || name.contains("motel") || name.contains("inn") ||
           name.contains("lodge") || name.contains("accommodation") {
            return CategoryRegistry.categoryOrDefault(for: "hotel")
        }
        
        // Default to unknown if we can't categorize
        return CategoryRegistry.unknownCategory
    }
    
    /// Build a formatted address string from CLPlacemark
    func buildAddress(from placemark: CLPlacemark) -> String {
        var addressComponents: [String] = []
        
        // Add street address
        if let streetNumber = placemark.subThoroughfare,
           let streetName = placemark.thoroughfare {
            addressComponents.append("\(streetNumber) \(streetName)")
        } else if let streetName = placemark.thoroughfare {
            addressComponents.append(streetName)
        }
        
        // Add city
        if let city = placemark.locality {
            addressComponents.append(city)
        }
        
        // Add state
        if let state = placemark.administrativeArea {
            addressComponents.append(state)
        }
        
        // Add postal code
        if let postalCode = placemark.postalCode {
            addressComponents.append(postalCode)
        }
        
        // Add country (if not US to avoid redundancy)
        if let country = placemark.country, country != "United States" {
            addressComponents.append(country)
        }
        
        return addressComponents.joined(separator: ", ")
    }
} 