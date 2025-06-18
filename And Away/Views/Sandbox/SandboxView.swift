import SwiftUI

struct GooglePlaceResult {
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let rating: Double?
    let priceLevel: String?
    let types: [String]
    let placeId: String
}

struct SandboxView: View {
    @State private var googleResults: [GooglePlaceResult] = []
    @State private var isSearching = false
    @State private var searchText = ""
    @State private var searchTimer: Timer?
    
    // Add your Google Places API key here
    private let googleAPIKey = "AIzaSyDuKI9Sn6gMj6yN8WUz4_TgeO1gjEo479E" // Replace with your actual key
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Google Places API (New) Sandbox")
                .font(.title)
                .padding()
            
            // Search Section
            VStack(alignment: .leading, spacing: 10) {
                Text("Google Places Text Search (New)")
                    .font(.headline)
                
                HStack {
                    TextField("Search for places", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: searchText) { _ in
                            debounceSearch()
                        }
                    
                    Button("Search") {
                        testGooglePlacesNew()
                    }
                    .disabled(isSearching)
                }
                
                if isSearching {
                    ProgressView("Searching...")
                        .frame(maxWidth: .infinity)
                }
                
                // Results Display
                if !googleResults.isEmpty {
                    Text("Results (\(googleResults.count)):")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(googleResults, id: \.placeId) { place in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(place.name)
                                        .font(.body)
                                        .fontWeight(.medium)
                                    
                                    Text(place.address)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    HStack {
                                        Text("Lat: \(place.latitude, specifier: "%.4f"), Lng: \(place.longitude, specifier: "%.4f")")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        
                                        if let rating = place.rating {
                                            Text("★ \(rating, specifier: "%.1f")")
                                                .font(.caption)
                                                .foregroundColor(.orange)
                                        }
                                        
                                        if let priceLevel = place.priceLevel {
                                            Text(priceLevel)
                                                .font(.caption)
                                                .foregroundColor(.green)
                                        }
                                    }
                                    
                                    if !place.types.isEmpty {
                                        Text("Types: \(place.types.prefix(3).joined(separator: ", "))")
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.vertical, 4)
                                Divider()
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            Spacer()
        }
        .padding()
    }
    
    private func testGooglePlacesNew() {
        guard googleAPIKey != "YOUR_GOOGLE_API_KEY" else {
            print("Error: Please add your Google Places API key to SandboxView.swift")
            return
        }
        
        isSearching = true
        googleResults = []
        
        // New Google Places API (v1) URL
        let urlString = "https://places.googleapis.com/v1/places:searchText"
        
        guard let url = URL(string: urlString) else {
            isSearching = false
            print("Error: Invalid URL")
            return
        }
        
        // Create the request body
        let requestBody: [String: Any] = [
            "textQuery": searchText,
            "locationBias": [
                "circle": [
                    "center": [
                        "latitude": 37.7749,
                        "longitude": -122.4194
                    ],
                    "radius": 5000.0
                ]
            ],
            "pageSize": 20
        ]
        
        // Convert to JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            isSearching = false
            print("Error: Failed to create JSON body")
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(googleAPIKey, forHTTPHeaderField: "X-Goog-Api-Key")
        
        // Set the field mask to specify which fields we want
        let fieldMask = "places.displayName,places.formattedAddress,places.location,places.rating,places.priceLevel,places.types,places.id"
        request.setValue(fieldMask, forHTTPHeaderField: "X-Goog-FieldMask")
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isSearching = false
                
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("Error: No data received")
                    return
                }
                
                // Parse JSON
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let places = json["places"] as? [[String: Any]] {
                        
                        // Simplified console logging for analysis
                        print("==== GOOGLE PLACES (NEW) ====")
                        print("Query: '\(searchText)' | Results: \(places.count)")
                        
                        googleResults = places.compactMap { place in
                            // Parse displayName (new format)
                            guard let displayNameObj = place["displayName"] as? [String: Any],
                                  let name = displayNameObj["text"] as? String else {
                                return nil
                            }
                            
                            // Parse address
                            let address = place["formattedAddress"] as? String ?? "Address not available"
                            
                            // Parse location (new format)
                            guard let location = place["location"] as? [String: Any],
                                  let lat = location["latitude"] as? Double,
                                  let lng = location["longitude"] as? Double else {
                                return nil
                            }
                            
                            // Parse rating
                            let rating = place["rating"] as? Double
                            
                            // Parse price level (new format - now a string)
                            let priceLevel = place["priceLevel"] as? String
                            
                            // Parse types
                            let types = place["types"] as? [String] ?? []
                            
                            // Parse place ID (from the "name" field in new API)
                            let placeId = place["id"] as? String ?? "unknown"
                            
                            return GooglePlaceResult(
                                name: name,
                                address: address,
                                latitude: lat,
                                longitude: lng,
                                rating: rating,
                                priceLevel: priceLevel,
                                types: types,
                                placeId: placeId
                            )
                        }
                        
                        // Log individual results
                        for (index, place) in googleResults.enumerated() {
                            print("[\(index + 1)] \(place.name)")
                        }
                        print("==== END GOOGLE (NEW) ====\n")
                    }
                } catch {
                    print("JSON parsing error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    private func debounceSearch() {
        // Cancel previous timer
        searchTimer?.invalidate()
        
        // Clear results if text is empty
        if searchText.isEmpty {
            googleResults = []
            return
        }
        
        // Create new timer with 0.5 second delay
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            DispatchQueue.main.async {
                testGooglePlacesNew()
            }
        }
    }
}

#Preview {
    SandboxView()
}
