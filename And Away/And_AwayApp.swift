//
//  And_AwayApp.swift
//  And Away
//
//  Created by Oliver Lukman on 29/05/2025.
//

import SwiftUI
import GooglePlacesSwift
import GoogleMaps

@main
struct And_AwayApp: App {
    
    init() {
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: path),
           let apiKey = plist["GooglePlacesAPIKey"] as? String {
            // Initialize Google Places
            PlacesClient.provideAPIKey(apiKey)
            // Initialize Google Maps with the same API key
            GMSServices.provideAPIKey(apiKey)
        } else {
            fatalError("Could not load Google Places API key from Config.plist")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainMapView()
            //SandboxView()
        }
    }
}
