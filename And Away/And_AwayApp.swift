//
//  And_AwayApp.swift
//  And Away
//
//  Created by Oliver Lukman on 29/05/2025.
//

import SwiftUI

@main
struct And_AwayApp: App {
    @StateObject private var locationService = LocationService.shared
    
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
