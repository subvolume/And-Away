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
        // Load API key from Config.plist
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let config = NSDictionary(contentsOfFile: path),
              let apiKey = config["GooglePlacesAPIKey"] as? String else {
            fatalError("Google API Key not found in Config.plist")
        }
        
        // Initialize Google Places and Maps SDKs
        PlacesClient.provideAPIKey(apiKey)
        GMSServices.provideAPIKey(apiKey)
    }
    
    var body: some Scene {
        WindowGroup {
            //MainMapView()
            SandboxView()
        }
    }
}
