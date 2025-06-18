import Foundation

class GooglePlacesService {
    private let apiKey: String
    
    // Netherlands coordinates for location-aware search (matching HTML tester)
    private let defaultLocation = "52.678606347967175,4.698801550831957"
    private let defaultRadius = "5000" // 5km radius (matching HTML tester)
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    // MARK: - Autocomplete Search
    func autocomplete(query: String) async throws -> [GooglePlace] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let sessionToken = UUID().uuidString
        
        // Include location and session token for consistent results matching testing
        let urlString = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(encodedQuery)&location=\(defaultLocation)&radius=\(defaultRadius)&sessiontoken=\(sessionToken)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw GooglePlacesError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(GoogleAutocompleteResponse.self, from: data)
        
        // Check API status
        guard response.status == "OK" else {
            throw GooglePlacesError.apiError(response.status)
        }
        
        return response.predictions.map { prediction in
            GooglePlace(
                placeId: prediction.placeId,
                name: prediction.structuredFormatting.mainText,
                vicinity: prediction.structuredFormatting.secondaryText,
                types: prediction.types,
                location: nil, // Autocomplete doesn't include coordinates
                photos: nil,
                formattedPhoneNumber: nil,
                openingHours: nil
            )
        }
    }
    
    // MARK: - Text Search
    func textSearch(query: String) async throws -> [GooglePlace] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        // Include location for consistent results matching testing
        let urlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(encodedQuery)&location=\(defaultLocation)&radius=\(defaultRadius)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw GooglePlacesError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(GooglePlacesSearchResponse.self, from: data)
        
        // Check API status
        guard response.status == "OK" else {
            throw GooglePlacesError.apiError(response.status)
        }
        
        return response.results.map { result in
            GooglePlace(
                placeId: result.placeId,
                name: result.name,
                vicinity: result.vicinity,
                types: result.types,
                location: result.geometry.location,
                photos: result.photos,
                formattedPhoneNumber: nil,
                openingHours: nil
            )
        }
    }
    
    // MARK: - Smart Search (Hybrid Approach)
    func smartSearch(query: String) async throws -> [GooglePlace] {
        if hasLocationContext(query) {
            print("🎯 Using Text Search API for: '\(query)'")
            return try await textSearch(query: query)
        } else {
            print("⚡ Using Autocomplete API for: '\(query)'")
            return try await autocomplete(query: query)
        }
    }
    
    private func hasLocationContext(_ query: String) -> Bool {
        let locationKeywords = ["near me", "nearby", "near", "in ", "around"]
        return locationKeywords.contains { keyword in
            query.lowercased().contains(keyword)
        }
    }
    
    // MARK: - Place Details (for complete information)
    func placeDetails(placeId: String) async throws -> GooglePlace {
        let urlString = "https://maps.googleapis.com/maps/api/place/details/json?place_id=\(placeId)&fields=place_id,name,vicinity,types,geometry,photos,formatted_phone_number,opening_hours&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw GooglePlacesError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(GooglePlaceDetailsResponse.self, from: data)
        
        // Check API status
        guard response.status == "OK" else {
            throw GooglePlacesError.apiError(response.status)
        }
        
        let result = response.result
        return GooglePlace(
            placeId: result.placeId,
            name: result.name,
            vicinity: result.vicinity,
            types: result.types,
            location: result.geometry.location,
            photos: result.photos,
            formattedPhoneNumber: result.formattedPhoneNumber,
            openingHours: result.openingHours
        )
    }
}

// MARK: - Error Handling
enum GooglePlacesError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case apiError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        case .apiError(let status):
            return "Google API Error: \(status)"
        }
    }
} 