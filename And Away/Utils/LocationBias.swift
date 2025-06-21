import Foundation
import CoreLocation
import GoogleMaps
import GooglePlacesSwift

/// Handles location bias calculations for place searches based on map state
struct LocationBiasHelper {
    
    /// Calculate search radius based on zoom level
    /// - Parameter zoom: Current map zoom level
    /// - Returns: Appropriate search radius in meters
    static func searchRadius(for zoom: Float) -> Double {
        switch zoom {
        case 0..<10:
            // Very zoomed out - country/continent level
            return 50000 // 50km
        case 10..<13:
            // City level
            return 20000 // 20km
        case 13..<15:
            // Neighborhood level
            return 5000 // 5km
        case 15..<17:
            // Street level
            return 2000 // 2km
        default:
            // Very zoomed in - immediate area
            return 1000 // 1km
        }
    }
    
    /// Create location bias for search based on map state
    /// - Parameters:
    ///   - visibleRegion: Current visible region of the map
    ///   - zoom: Current zoom level
    ///   - userLocation: User's current location (optional)
    /// - Returns: Location bias for Google Places search
    static func createSearchBias(
        visibleRegion: GMSVisibleRegion,
        zoom: Float,
        userLocation: CLLocationCoordinate2D?
    ) -> CircularCoordinateRegion {
        // Calculate center of visible region
        let centerLat = (visibleRegion.farLeft.latitude + visibleRegion.nearRight.latitude) / 2
        let centerLng = (visibleRegion.farLeft.longitude + visibleRegion.nearRight.longitude) / 2
        let mapCenter = CLLocationCoordinate2D(latitude: centerLat, longitude: centerLng)
        
        // Use dynamic radius based on zoom level
        let radius = searchRadius(for: zoom)
        
        // If user is looking at area near their location, use user location
        // Otherwise use map center
        let biasCenter: CLLocationCoordinate2D
        if let userLocation = userLocation,
           isCoordinate(userLocation, within: radius * 2, of: mapCenter) {
            biasCenter = userLocation
        } else {
            biasCenter = mapCenter
        }
        
        return CircularCoordinateRegion(center: biasCenter, radius: radius)
    }
    
    /// Create rectangular bias using visible region bounds
    /// - Parameters:
    ///   - visibleRegion: Current visible region of the map
    ///   - topPercentage: Percentage of top area to use (0.7 = 70%)
    /// - Returns: Rectangular location bias
    static func createRectangularBias(
        visibleRegion: GMSVisibleRegion,
        topPercentage: Double = 0.7
    ) -> RectangularCoordinateRegion? {
        // Calculate the bounds
        let minLat = min(visibleRegion.nearLeft.latitude, visibleRegion.nearRight.latitude)
        let maxLat = max(visibleRegion.farLeft.latitude, visibleRegion.farRight.latitude)
        let minLng = min(visibleRegion.nearLeft.longitude, visibleRegion.farLeft.longitude)
        let maxLng = max(visibleRegion.nearRight.longitude, visibleRegion.farRight.longitude)
        
        // Adjust for top percentage (reduce from bottom)
        let latRange = maxLat - minLat
        let adjustedMinLat = minLat + (latRange * (1 - topPercentage))
        
        let southWest = CLLocationCoordinate2D(latitude: adjustedMinLat, longitude: minLng)
        let northEast = CLLocationCoordinate2D(latitude: maxLat, longitude: maxLng)
        
        return RectangularCoordinateRegion(northEast: northEast, southWest: southWest)
    }
    
    /// Check if a coordinate is within a certain distance of another
    private static func isCoordinate(
        _ coord1: CLLocationCoordinate2D,
        within distance: Double,
        of coord2: CLLocationCoordinate2D
    ) -> Bool {
        let location1 = CLLocation(latitude: coord1.latitude, longitude: coord1.longitude)
        let location2 = CLLocation(latitude: coord2.latitude, longitude: coord2.longitude)
        return location1.distance(from: location2) <= distance
    }
} 