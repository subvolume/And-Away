import Foundation

// MARK: - Google Directions Response
struct GoogleDirectionsResponse: Codable {
    let routes: [DirectionRoute]
    let status: String
    let geocodedWaypoints: [GeocodedWaypoint]?
    
    enum CodingKeys: String, CodingKey {
        case routes
        case status
        case geocodedWaypoints = "geocoded_waypoints"
    }
}

// MARK: - Direction Route
struct DirectionRoute: Codable, Identifiable {
    let id = UUID()
    let bounds: RouteBounds
    let legs: [RouteLeg]
    let overviewPolyline: RoutePolyline
    let summary: String
    let warnings: [String]?
    let waypointOrder: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case bounds
        case legs
        case overviewPolyline = "overview_polyline"
        case summary
        case warnings
        case waypointOrder = "waypoint_order"
    }
}

// MARK: - Route Leg (from point A to point B)
struct RouteLeg: Codable, Identifiable {
    let id = UUID()
    let distance: RouteDistance
    let duration: RouteDuration
    let durationInTraffic: RouteDuration?
    let endAddress: String
    let endLocation: PlaceLocation
    let startAddress: String
    let startLocation: PlaceLocation
    let steps: [RouteStep]
    
    enum CodingKeys: String, CodingKey {
        case distance
        case duration
        case durationInTraffic = "duration_in_traffic"
        case endAddress = "end_address"
        case endLocation = "end_location"
        case startAddress = "start_address"
        case startLocation = "start_location"
        case steps
    }
}

// MARK: - Route Step (individual direction instruction)
struct RouteStep: Codable, Identifiable {
    let id = UUID()
    let distance: RouteDistance
    let duration: RouteDuration
    let endLocation: PlaceLocation
    let htmlInstructions: String
    let polyline: RoutePolyline
    let startLocation: PlaceLocation
    let travelMode: String
    let maneuver: String?
    
    enum CodingKeys: String, CodingKey {
        case distance
        case duration
        case endLocation = "end_location"
        case htmlInstructions = "html_instructions"
        case polyline
        case startLocation = "start_location"
        case travelMode = "travel_mode"
        case maneuver
    }
}

// MARK: - Supporting Structures
struct RouteDistance: Codable {
    let text: String
    let value: Int // in meters
}

struct RouteDuration: Codable {
    let text: String
    let value: Int // in seconds
}

struct RoutePolyline: Codable {
    let points: String
}

struct RouteBounds: Codable {
    let northeast: PlaceLocation
    let southwest: PlaceLocation
}

struct GeocodedWaypoint: Codable {
    let geocoderStatus: String
    let placeId: String?
    let types: [String]
    
    enum CodingKeys: String, CodingKey {
        case geocoderStatus = "geocoder_status"
        case placeId = "place_id"
        case types
    }
} 