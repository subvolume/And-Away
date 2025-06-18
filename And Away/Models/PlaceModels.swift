import Foundation
import CoreLocation
import GooglePlacesSwift

// MARK: - Unified Place Model

/// Unified place model used throughout the "And Away" app
/// This model consolidates place data from various sources (primarily Google Places SDK)
/// into a consistent structure that our app can work with.
struct Place: Identifiable, Hashable {
    let id: String
    let name: String
    let location: CLLocationCoordinate2D
    let address: PlaceAddress
    let category: PlaceCategory
    let details: PlaceDetails
    let photos: [PlacePhoto]
    
    /// Unique identifier for SwiftUI lists
    var swiftUIID: String { id }
}

// MARK: - Supporting Models

struct PlaceAddress: Hashable {
    let fullAddress: String
    let city: String
    let state: String?
    let country: String?
    let postalCode: String?
    
    /// Short address for display (e.g., "123 Main St, San Francisco")
    var shortAddress: String {
        let components = [fullAddress.components(separatedBy: ",").first ?? "", city]
            .compactMap { $0.isEmpty ? nil : $0.trimmingCharacters(in: .whitespaces) }
        return components.joined(separator: ", ")
    }
}

struct PlaceCategory: Hashable {
    let primaryType: String
    let displayName: String
    let icon: String
    let color: String
    
    /// Default category for unknown place types
    static let unknown = PlaceCategory(
        primaryType: "unknown",
        displayName: "Place",
        icon: "mappin",
        color: "gray"
    )
}

struct PlaceDetails: Hashable {
    let phoneNumber: String?
    let website: String?
    let rating: Double?
    let priceLevel: PriceLevel?
    let businessHours: BusinessHours?
    let isOpenNow: Bool?
    
    /// Formatted rating string (e.g., "4.5" or "No rating")
    var ratingText: String {
        guard let rating = rating else { return "No rating" }
        return String(format: "%.1f", rating)
    }
    
    /// Price level as dollar signs (e.g., "$$")
    var priceLevelText: String {
        guard let priceLevel = priceLevel else { return "" }
        switch priceLevel {
        case .free: return "Free"
        case .inexpensive: return "$"
        case .moderate: return "$$"
        case .expensive: return "$$$"
        case .veryExpensive: return "$$$$"
        case .unspecified: return ""
        @unknown default: return ""
        }
    }
}

struct BusinessHours: Hashable {
    let weekdayText: [String]
    let isOpen24Hours: Bool
    
    /// Today's hours text
    var todayHours: String? {
        let today = Calendar.current.component(.weekday, from: Date())
        // Weekday component returns 1-7 (Sunday = 1), but weekdayText is 0-6 (Monday = 0)
        let index = (today == 1) ? 6 : today - 2 // Convert Sunday=1 to index=6, Monday=2 to index=0, etc.
        guard weekdayText.indices.contains(index) else { return nil }
        return weekdayText[index]
    }
}

struct PlacePhoto: Identifiable, Hashable {
    let id: String
    let reference: String
    let width: Int
    let height: Int
    let attributions: [String]
    
    /// Aspect ratio for display purposes
    var aspectRatio: Double {
        guard height > 0 else { return 1.0 }
        return Double(width) / Double(height)
    }
}

// MARK: - Distance Calculation

extension Place {
    /// Calculate distance from user's location
    func distance(from userLocation: CLLocationCoordinate2D) -> CLLocationDistance {
        let placeLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        return placeLocation.distance(from: userCLLocation)
    }
    
    /// Formatted distance string (e.g., "0.5 mi" or "1.2 km")
    func distanceText(from userLocation: CLLocationCoordinate2D, useMetric: Bool = false) -> String {
        let distance = distance(from: userLocation)
        
        if useMetric {
            if distance < 1000 {
                return String(format: "%.0f m", distance)
            } else {
                return String(format: "%.1f km", distance / 1000)
            }
        } else {
            let miles = distance * 0.000621371
            if miles < 0.1 {
                let feet = distance * 3.28084
                return String(format: "%.0f ft", feet)
            } else {
                return String(format: "%.1f mi", miles)
            }
        }
    }
}

// MARK: - Hashable Conformance for CLLocationCoordinate2D

extension CLLocationCoordinate2D: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
    
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

// MARK: - Sample Data

extension Place {
    /// Sample place for previews and testing
    static let sample = Place(
        id: "sample_place_1",
        name: "Sample Coffee Shop",
        location: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        address: PlaceAddress(
            fullAddress: "123 Main Street, San Francisco, CA 94102",
            city: "San Francisco",
            state: "CA",
            country: "United States",
            postalCode: "94102"
        ),
        category: PlaceCategory(
            primaryType: "cafe",
            displayName: "Coffee Shop",
            icon: "cup.and.saucer.fill",
            color: "brown"
        ),
        details: PlaceDetails(
            phoneNumber: "+1 (555) 123-4567",
            website: "https://example.com",
            rating: 4.5,
            priceLevel: .moderate,
            businessHours: BusinessHours(
                weekdayText: [
                    "Monday: 7:00 AM – 7:00 PM",
                    "Tuesday: 7:00 AM – 7:00 PM",
                    "Wednesday: 7:00 AM – 7:00 PM",
                    "Thursday: 7:00 AM – 7:00 PM",
                    "Friday: 7:00 AM – 7:00 PM",
                    "Saturday: 8:00 AM – 6:00 PM",
                    "Sunday: 8:00 AM – 6:00 PM"
                ],
                isOpen24Hours: false
            ),
            isOpenNow: true
        ),
        photos: []
    )
} 