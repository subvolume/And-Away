//
//  LocationService.swift
//  And Away
//
//  Created by Oliver Lukman on 29/05/2025.
//

import Foundation
import CoreLocation
import SwiftUI

// MARK: - Location Service
@MainActor
class LocationService: NSObject, ObservableObject {
    static let shared = LocationService()
    
    @Published var currentLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var hasPermission: Bool = false
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        setupLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        hasPermission = authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }
    
    // MARK: - Setup
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100 // Update only if moved 100m
    }
    
    // MARK: - Request Permission
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - Start/Stop Location Updates
    func startLocationUpdates() {
        guard hasPermission else { return }
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Get Location String
    func getCurrentLocationString() -> String? {
        guard let location = currentLocation else { return nil }
        return "\(location.coordinate.latitude),\(location.coordinate.longitude)"
    }
    
    // MARK: - Get Nearby Location Fallback
    func getNearbyLocationFallback(from destination: PlaceLocation) -> String {
        // Generate a point roughly 3-5km away from the destination
        let latOffset = 0.03 // roughly 3km
        let lngOffset = 0.03
        
        let nearbyLat = destination.lat + latOffset
        let nearbyLng = destination.lng + lngOffset
        
        return "\(nearbyLat),\(nearbyLng)"
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle location error silently
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        hasPermission = status == .authorizedWhenInUse || status == .authorizedAlways
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdates()
        case .denied, .restricted:
            stopLocationUpdates()
            currentLocation = nil
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
} 