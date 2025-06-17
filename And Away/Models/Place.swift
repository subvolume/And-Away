//
//  Place.swift
//  And Away
//
//  Core place data model - provider agnostic
//

import Foundation
import CoreLocation
import SwiftUI

// MARK: - Core Place Model

/// Core place information that works with any map provider
struct Place: Identifiable {
    let id: String                          // Unique identifier
    let name: String                        // Name of place
    let latitude: Double                    // Latitude coordinate
    let longitude: Double                   // Longitude coordinate
    let locality: String                    // City/area name
    let category: PlaceCategory             // Standardized category
    let isOpen: OpenStatus?                 // Open/closed status
    let photos: [PlaceImageInfo]            // Place images (renamed to avoid conflict)
    let distanceFromUser: Double?           // Distance in meters
    let address: String                     // Full address
    let phoneNumber: String?                // Contact number
    let website: URL?                       // Official website
    let googleMapsLink: URL?                // Google Maps link
    let tripadvisorLink: URL?               // TripAdvisor link
    
    /// Computed CLLocation from latitude/longitude
    var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
}

// MARK: - Supporting Models

/// Open/closed status of a place
enum OpenStatus: Codable {
    case open
    case closed
    case unknown
    case openUntil(Date)
    case opensAt(Date)
}

/// Place photo information (renamed to avoid conflict with existing PlacePhoto)
struct PlaceImageInfo: Identifiable, Codable {
    let id: String
    let url: URL
    let width: Int?
    let height: Int?
    let attributions: [String]              // Photo credits/attributions
}

/// Place category with visual styling
struct PlaceCategory: Identifiable {
    let id: String
    let displayName: String
    let icon: String                        // SF Symbol name
    let color: Color                        // SwiftUI Color
    let priority: Int                       // Display order
}

// MARK: - Extensions

extension Place {
    /// Computed property for easy distance formatting
    var formattedDistance: String? {
        guard let distance = distanceFromUser else { return nil }
        
        if distance < 1000 {
            return "\(Int(distance))m"
        } else {
            let km = distance / 1000
            return String(format: "%.1fkm", km)
        }
    }
    
    /// Check if place has photos
    var hasPhotos: Bool {
        !photos.isEmpty
    }
    
    /// Get primary photo (first one)
    var primaryPhoto: PlaceImageInfo? {
        photos.first
    }
}

extension OpenStatus {
    /// User-friendly description of open status
    var description: String {
        switch self {
        case .open:
            return "Open"
        case .closed:
            return "Closed"
        case .unknown:
            return "Hours unknown"
        case .openUntil(let date):
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return "Open until \(formatter.string(from: date))"
        case .opensAt(let date):
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return "Opens at \(formatter.string(from: date))"
        }
    }
    
    /// Whether the place is currently open
    var isCurrentlyOpen: Bool {
        switch self {
        case .open, .openUntil:
            return true
        case .closed, .opensAt, .unknown:
            return false
        }
    }
} 