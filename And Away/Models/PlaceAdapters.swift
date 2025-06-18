import Foundation
import CoreLocation
import GooglePlacesSwift

// MARK: - Google Places SDK Adapters

/// Converts Google Places SDK models to our unified Place model
/// This keeps our app decoupled from Google's specific model structure
struct GooglePlaceAdapter {
    
    /// Convert Google Places SDK Place to our unified Place model
    static func convert(_ googlePlace: GooglePlacesSwift.Place) -> Place {
        return Place(
            id: googlePlace.id,
            name: googlePlace.displayName ?? "Unknown Place",
            location: googlePlace.location ?? CLLocationCoordinate2D(latitude: 0, longitude: 0),
            address: convertAddress(googlePlace),
            category: convertCategory(googlePlace),
            details: convertDetails(googlePlace),
            photos: convertPhotos(googlePlace.photos ?? [])
        )
    }
    
    /// Convert array of Google Places to our unified model
    static func convert(_ googlePlaces: [GooglePlacesSwift.Place]) -> [Place] {
        return googlePlaces.map { convert($0) }
    }
}

// MARK: - Address Conversion

private extension GooglePlaceAdapter {
    static func convertAddress(_ googlePlace: GooglePlacesSwift.Place) -> PlaceAddress {
        // Extract address components from Google Place
        let fullAddress = googlePlace.formattedAddress ?? ""
        
        // Parse city, state, country from address components
        let addressComponents = googlePlace.addressComponents ?? []
        
        var city = ""
        var state: String?
        var country: String?
        var postalCode: String?
        
        for component in addressComponents {
            let types = component.types
            
            if types.contains("locality") {
                city = component.longName ?? ""
            } else if types.contains("administrative_area_level_1") {
                state = component.shortName
            } else if types.contains("country") {
                country = component.longName
            } else if types.contains("postal_code") {
                postalCode = component.longName
            }
        }
        
        // Fallback: extract city from formatted address if not found in components
        if city.isEmpty {
            let addressParts = fullAddress.components(separatedBy: ", ")
            if addressParts.count >= 2 {
                city = addressParts[addressParts.count - 2] // Second to last part is usually city
            }
        }
        
        return PlaceAddress(
            fullAddress: fullAddress,
            city: city,
            state: state,
            country: country,
            postalCode: postalCode
        )
    }
}

// MARK: - Category Conversion

private extension GooglePlaceAdapter {
    static func convertCategory(_ googlePlace: GooglePlacesSwift.Place) -> PlaceCategory {
        // Get primary type from Google Place
        let primaryType = googlePlace.primaryType?.rawValue ?? "unknown"
        
        // Use our categorization system to get display info
        return PlaceCategorization.category(for: primaryType)
    }
}

// MARK: - Details Conversion

private extension GooglePlaceAdapter {
    static func convertDetails(_ googlePlace: GooglePlacesSwift.Place) -> PlaceDetails {
        // Convert business hours
        let businessHours = convertBusinessHours(googlePlace.currentOpeningHours)
        
        return PlaceDetails(
            phoneNumber: googlePlace.nationalPhoneNumber,
            website: googlePlace.websiteURI?.absoluteString,
            rating: googlePlace.rating,
            priceLevel: googlePlace.priceLevel,
            businessHours: businessHours,
            isOpenNow: googlePlace.currentOpeningHours?.openNow
        )
    }
    
    static func convertBusinessHours(_ openingHours: GooglePlacesSwift.OpeningHours?) -> BusinessHours? {
        guard let openingHours = openingHours else { return nil }
        
        return BusinessHours(
            weekdayText: openingHours.weekdayText ?? [],
            isOpen24Hours: false // Google SDK doesn't explicitly provide this, would need to parse weekdayText
        )
    }
}

// MARK: - Photos Conversion

private extension GooglePlaceAdapter {
    static func convertPhotos(_ googlePhotos: [GooglePlacesSwift.Photo]) -> [PlacePhoto] {
        return googlePhotos.compactMap { photo in
            guard let width = photo.maxSize?.width,
                  let height = photo.maxSize?.height else {
                return nil
            }
            
            return PlacePhoto(
                id: UUID().uuidString, // Google doesn't provide a unique ID for photos
                reference: photo.name, // Use photo name as reference
                width: Int(width),
                height: Int(height),
                attributions: photo.authorAttributions?.compactMap { $0.displayName } ?? []
            )
        }
    }
}

// MARK: - Search Request Builders

extension GooglePlaceAdapter {
    
    /// Build a Text Search request with common parameters
    static func buildTextSearchRequest(
        query: String,
        location: CLLocationCoordinate2D? = nil,
        radius: Double = 5000, // 5km default
        maxResults: Int = 20
    ) -> SearchByTextRequest {
        
        // Define which place properties we want to fetch
        let placeProperties: [PlaceProperty] = [
            .id,
            .displayName,
            .location,
            .formattedAddress,
            .addressComponents,
            .primaryType,
            .rating,
            .priceLevel,
            .nationalPhoneNumber,
            .websiteURI,
            .currentOpeningHours,
            .photos
        ]
        
        // Create location bias if user location is provided
        let locationBias: (any CoordinateRegionBias)? = location.map { coord in
            CircularCoordinateRegion(center: coord, radius: radius)
        }
        
        return SearchByTextRequest(
            textQuery: query,
            placeProperties: placeProperties,
            locationBias: locationBias,
            maxResultCount: maxResults,
            rankPreference: .distance
        )
    }
    
    /// Build a Nearby Search request with common parameters
    static func buildNearbySearchRequest(
        center: CLLocationCoordinate2D,
        radius: Double = 1000, // 1km default for nearby
        includedTypes: Set<PlaceType>? = nil,
        maxResults: Int = 20
    ) -> SearchNearbyRequest {
        
        // Define which place properties we want to fetch
        let placeProperties: [PlaceProperty] = [
            .id,
            .displayName,
            .location,
            .formattedAddress,
            .addressComponents,
            .primaryType,
            .rating,
            .priceLevel,
            .nationalPhoneNumber,
            .websiteURI,
            .currentOpeningHours,
            .photos
        ]
        
        // Create location restriction (required for nearby search)
        let locationRestriction = CircularCoordinateRegion(center: center, radius: radius)
        
        return SearchNearbyRequest(
            locationRestriction: locationRestriction,
            placeProperties: placeProperties,
            includedTypes: includedTypes,
            maxResultCount: maxResults,
            rankPreference: .distance
        )
    }
} 