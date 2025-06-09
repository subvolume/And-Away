//
//  And_AwayApp.swift
//  And Away
//
//  Created by Oliver Lukman on 29/05/2025.
//

import SwiftUI
import GoogleMaps

@main
struct And_AwayApp: App {
    @StateObject private var locationService = LocationService.shared
    
    init() {
        // Configure Google Maps with API key
        GMSServices.provideAPIKey("AIzaSyD8ph4-zjHFk5JmPRoHNuBTNacwQi0x8IU")
    }
    
    var body: some Scene {
        WindowGroup {
            MainMapView()
                .environmentObject(locationService)
                .onAppear {
                    // Request location permission when app launches
                    locationService.requestLocationPermission()
                }
            //SandboxView()
        }
    }
}
