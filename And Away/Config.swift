import Foundation

struct Config {
    
    // MARK: - Google Places API
    static var googlePlacesAPIKey: String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let key = plist["GooglePlacesAPIKey"] as? String else {
            fatalError("Google Places API Key not found in Config.plist")
        }
        return key
    }
    
    // MARK: - Build Configuration
    static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    // MARK: - API Settings
    static var apiTimeout: TimeInterval { 10.0 }
    static var searchDebounceTime: TimeInterval { 0.5 }
    
    // MARK: - Location Settings  
    static var defaultLocation: String { "52.678606347967175,4.698801550831957" } // Netherlands
    static var defaultRadius: String { "5000" } // 5km
} 