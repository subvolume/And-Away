//
//  PlaceDetailsTravel.swift
//  And Away
//
//  Created by Oliver Lukman on 29/05/2025.
//

import SwiftUI
import CoreLocation

struct PlaceDetailsTravel: View {
    // MARK: - Properties
    let place: PlaceDetails
    let userLocation: String // e.g., "48.8566,2.3522" or "Current Location"
    
    @State private var walkingTime: String = "..."
    @State private var drivingTime: String = "..."
    @State private var transitTime: String = "..."
    @State private var distance: String = "..."
    @State private var isLoading = false
    
    @EnvironmentObject private var locationService: LocationService
    private let googleAPI = GoogleAPIService.shared
    
    // MARK: - Initializer
    init(place: PlaceDetails, userLocation: String = "Current Location") {
        self.place = place
        self.userLocation = userLocation
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            HStack(spacing: Spacing.xs) {
                PillButton.iconAboveText(text: distance, icon: "location.fill") {
                    print("Distance tapped: \(distance)")
                }
                
                PillButton.iconAboveText(text: walkingTime, icon: "figure.walk") {
                    print("Walking tapped: \(walkingTime)")
                }
                
                PillButton.iconAboveText(text: drivingTime, icon: "car.fill") {
                    print("Driving tapped: \(drivingTime)")
                }
                
                PillButton.iconAboveText(text: transitTime, icon: "bus.fill") {
                    print("Public Transport tapped: \(transitTime)")
                }
            }
        }
        .padding()
        .onAppear {
            fetchAllDirections()
        }
        .onChange(of: locationService.currentLocation) { _ in
            fetchAllDirections()
        }
    }
    
    // MARK: - Fetch All Directions
    private func fetchAllDirections() {
        guard !isLoading else { return }
        
        isLoading = true
        let destination = "\(place.geometry.location.lat),\(place.geometry.location.lng)"
        
        // Use real user location if available, otherwise use nearby location
        let origin: String
        if let currentLocationString = locationService.getCurrentLocationString() {
            origin = currentLocationString
        } else if userLocation != "Current Location" {
            origin = userLocation
        } else {
            origin = locationService.getNearbyLocationFallback(from: place.geometry.location)
        }
        
        Task {
            // Fetch all travel modes in parallel
            async let walkingDirections = fetchDirections(mode: .walking, origin: origin, destination: destination)
            async let drivingDirections = fetchDirections(mode: .driving, origin: origin, destination: destination)
            async let transitDirections = fetchDirections(mode: .transit, origin: origin, destination: destination)
            
            // Wait for all results
            let results = await (
                walking: walkingDirections,
                driving: drivingDirections,
                transit: transitDirections
            )
            
            // Update UI on main thread
            await MainActor.run {
                updateTravelTimes(
                    walking: results.walking,
                    driving: results.driving,
                    transit: results.transit
                )
                isLoading = false
            }
        }
    }
    
    // MARK: - Fetch Directions for Specific Mode
    private func fetchDirections(mode: TravelMode, origin: String, destination: String) async -> GoogleDirectionsResponse? {
        do {
            let response = try await googleAPI.getDirections(
                origin: origin,
                destination: destination,
                mode: mode
            )
            return response
        } catch {
            return nil
        }
    }
    
    // MARK: - Update Travel Times
    private func updateTravelTimes(
        walking: GoogleDirectionsResponse?,
        driving: GoogleDirectionsResponse?,
        transit: GoogleDirectionsResponse?
    ) {
        // Update distance (use walking distance as base)
        if let walkingRoute = walking?.routes.first?.legs.first {
            distance = walkingRoute.distance.text
        } else {
            distance = "N/A"
        }
        
        // Update walking time
        if let walkingRoute = walking?.routes.first?.legs.first {
            walkingTime = walkingRoute.duration.text
        } else {
            walkingTime = "N/A"
        }
        
        // Update driving time (use duration in traffic if available)
        if let drivingRoute = driving?.routes.first?.legs.first {
            if let trafficDuration = drivingRoute.durationInTraffic {
                drivingTime = trafficDuration.text
            } else {
                drivingTime = drivingRoute.duration.text
            }
        } else {
            drivingTime = "N/A"
        }
        
        // Update transit time
        if let transitRoute = transit?.routes.first?.legs.first {
            transitTime = transitRoute.duration.text
        } else {
            transitTime = "N/A"
        }
    }
    

}



// MARK: - Preview
struct PlaceDetailsTravel_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetailsTravel(
            place: MockData.samplePlaceDetails.result,
            userLocation: "48.8606,2.3376"
        )
        .environmentObject(LocationService.shared)
        .background(Color.backgroundPrimary)
        .previewLayout(.sizeThatFits)
    }
} 