import SwiftUI
import MapKit

struct GooglePlaceResult {
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let rating: Double?
    let priceLevel: Int?
}

enum SearchProvider {
    case apple
    case google
}

enum GoogleEndpoint {
    case textSearch
    case autocomplete
    case placeDetails
    case nearbySearch
    case placePhotos
    
    var displayName: String {
        switch self {
        case .textSearch: return "Text Search"
        case .autocomplete: return "Autocomplete"
        case .placeDetails: return "Place Details"
        case .nearbySearch: return "Nearby Search"
        case .placePhotos: return "Place Photos"
        }
    }
}

struct SandboxView: View {
    @State private var searchResults: [MKMapItem] = []
    @State private var googleResults: [GooglePlaceResult] = []
    @State private var isSearching = false
    @State private var searchText = ""
    @State private var selectedProvider: SearchProvider = .apple
    @State private var selectedGoogleEndpoint: GoogleEndpoint = .textSearch
    @State private var showRawResponse = false
    @State private var rawResponse = ""
    @State private var searchAsYouType = false
    @State private var searchTimer: Timer?
    @State private var placeId = "" // For Place Details testing
    
    // Add your Google Places API key here
    private let googleAPIKey = "AIzaSyDuKI9Sn6gMj6yN8WUz4_TgeO1gjEo479E" // Replace with your actual key
    
    // Computed properties for dynamic UI text
    private var searchSectionTitle: String {
        if selectedProvider == .apple {
            return "Apple MapKit Search Test"
        } else {
            return "Google Places \(selectedGoogleEndpoint.displayName) Test"
        }
    }
    
    private var searchPlaceholder: String {
        switch selectedGoogleEndpoint {
        case .textSearch, .nearbySearch, .autocomplete:
            return "Search for places"
        case .placeDetails:
            return "Enter place ID above"
        case .placePhotos:
            return "Enter photo reference"
        }
    }
    
    private var searchButtonTitle: String {
        if selectedProvider == .apple {
            return "Search"
        } else {
            switch selectedGoogleEndpoint {
            case .textSearch: return "Text Search"
            case .autocomplete: return "Autocomplete"
            case .placeDetails: return "Get Details"
            case .nearbySearch: return "Find Nearby"
            case .placePhotos: return "Get Photo"
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Provider Selection
            Picker("API Provider", selection: $selectedProvider) {
                Text("Apple MapKit").tag(SearchProvider.apple)
                Text("Google Places").tag(SearchProvider.google)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            // Google Endpoint Selection (only show when Google is selected)
            if selectedProvider == .google {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Google Places Endpoint:")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Picker("Google Endpoint", selection: $selectedGoogleEndpoint) {
                            Text("Text Search").tag(GoogleEndpoint.textSearch)
                            Text("Autocomplete").tag(GoogleEndpoint.autocomplete)
                            Text("Place Details").tag(GoogleEndpoint.placeDetails)
                            Text("Nearby Search").tag(GoogleEndpoint.nearbySearch)
                            Text("Place Photos").tag(GoogleEndpoint.placePhotos)
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        Spacer()
                    }
                    
                    // Special input for Place Details
                    if selectedGoogleEndpoint == .placeDetails {
                        TextField("Place ID (get from other searches)", text: $placeId)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.caption)
                    }
                }
                .padding(.horizontal)
            }
            
            // Search Section
            VStack(alignment: .leading, spacing: 10) {
                Text(searchSectionTitle)
                    .font(.headline)
                
                HStack {
                    TextField(searchPlaceholder, text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: searchText) { _ in
                            if searchAsYouType && selectedProvider == .google && 
                               (selectedGoogleEndpoint == .textSearch || selectedGoogleEndpoint == .autocomplete) {
                                debounceSearch()
                            } else if searchAsYouType && selectedProvider == .apple {
                                debounceSearch()
                            }
                        }
                    
                    Button(searchButtonTitle) {
                        if selectedProvider == .apple {
                            testAppleMapKit()
                        } else {
                            testSelectedGoogleEndpoint()
                        }
                    }
                    .disabled(isSearching || (selectedGoogleEndpoint == .placeDetails && placeId.isEmpty))
                }
                
                // Options
                HStack {
                    Toggle("Search as you type", isOn: $searchAsYouType)
                        .font(.caption)
                    
                    Spacer()
                    
                    Toggle("Show Raw Response", isOn: $showRawResponse)
                        .font(.caption)
                }
                
                if isSearching {
                    ProgressView("Searching...")
                        .frame(maxWidth: .infinity)
                }
                
                // Results Display
                if selectedProvider == .apple && !searchResults.isEmpty {
                    Text("Apple Results (\(searchResults.count)):")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(searchResults, id: \.self) { item in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.name ?? "Unknown")
                                        .font(.body)
                                        .fontWeight(.medium)
                                    
                                    if let address = item.placemark.title {
                                        Text(address)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    if let coordinate = item.placemark.location?.coordinate {
                                        Text("Lat: \(coordinate.latitude, specifier: "%.4f"), Lng: \(coordinate.longitude, specifier: "%.4f")")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.vertical, 4)
                                Divider()
                            }
                        }
                    }
                    .frame(maxHeight: 400)
                }
                
                if selectedProvider == .google && !googleResults.isEmpty {
                    Text("Google Results (\(googleResults.count)):")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(googleResults, id: \.name) { place in
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
                                            Text(String(repeating: "$", count: priceLevel))
                                                .font(.caption)
                                                .foregroundColor(.green)
                                        }
                                    }
                                }
                                .padding(.vertical, 4)
                                Divider()
                            }
                        }
                    }
                    .frame(maxHeight: 400)
                }
                
                // Raw Response Display
                if showRawResponse && !rawResponse.isEmpty {
                    Text("Raw API Response:")
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    ScrollView {
                        Text(rawResponse)
                            .font(.caption)
                            .textSelection(.enabled)
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(4)
                    }
                    .frame(maxHeight: 150)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            Spacer()
        }
        .padding()
    }
    
    private func testAppleMapKit() {
        isSearching = true
        searchResults = []
        rawResponse = ""
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 52.678606347967175, longitude: 4.698801550831957), // Your location
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            DispatchQueue.main.async {
                isSearching = false
                
                if let error = error {
                    print("MapKit search error: \(error.localizedDescription)")
                    rawResponse = "Error: \(error.localizedDescription)"
                    return
                }
                
                if let response = response {
                    searchResults = response.mapItems
                    
                    // Simplified console logging for analysis
                    print("==== APPLE MAPKIT ====")
                    print("Query: '\(searchText)' | Results: \(searchResults.count)")
                    for (index, item) in response.mapItems.enumerated() {
                        print("[\(index + 1)] \(item.name ?? "Unknown")")
                    }
                    print("==== END APPLE ====\n")
                    
                    // Create raw response for display
                    rawResponse = "Found \(searchResults.count) results:\n\n"
                    for (index, item) in response.mapItems.enumerated() {
                        rawResponse += "[\(index + 1)] \(item.name ?? "Unknown")\n"
                        rawResponse += "Address: \(item.placemark.title ?? "Unknown")\n"
                        if let coord = item.placemark.location?.coordinate {
                            rawResponse += "Coordinates: \(coord.latitude), \(coord.longitude)\n"
                        }
                        rawResponse += "\n"
                    }
                }
            }
        }
    }
    
    private func testSelectedGoogleEndpoint() {
        switch selectedGoogleEndpoint {
        case .textSearch:
            testGoogleTextSearch()
        case .autocomplete:
            testGoogleAutocomplete()
        case .placeDetails:
            testGooglePlaceDetails()
        case .nearbySearch:
            testGoogleNearbySearch()
        case .placePhotos:
            testGooglePlacePhotos()
        }
    }
    
    private func testGoogleTextSearch() {
        guard googleAPIKey != "YOUR_GOOGLE_API_KEY" else {
            rawResponse = "Error: Please add your Google Places API key to SandboxView.swift"
            return
        }
        
        isSearching = true
        googleResults = []
        rawResponse = ""
        
        let encodedQuery = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(encodedQuery)&location=52.678606347967175,4.698801550831957&radius=5000&key=\(googleAPIKey)"
        
        guard let url = URL(string: urlString) else {
            isSearching = false
            rawResponse = "Error: Invalid URL"
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isSearching = false
                
                if let error = error {
                    rawResponse = "Error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    rawResponse = "Error: No data received"
                    return
                }
                
                // Store raw response
                if let jsonString = String(data: data, encoding: .utf8) {
                    rawResponse = jsonString
                }
                
                // Parse JSON
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let results = json["results"] as? [[String: Any]] {
                        
                        // Simplified console logging for analysis
                        print("==== GOOGLE TEXT SEARCH ====")
                        print("Query: '\(searchText)' | Results: \(results.count)")
                        
                        googleResults = results.compactMap { result in
                            guard let name = result["name"] as? String,
                                  let address = result["formatted_address"] as? String,
                                  let geometry = result["geometry"] as? [String: Any],
                                  let location = geometry["location"] as? [String: Any],
                                  let lat = location["lat"] as? Double,
                                  let lng = location["lng"] as? Double else {
                                return nil
                            }
                            
                            let rating = result["rating"] as? Double
                            let priceLevel = result["price_level"] as? Int
                            
                            return GooglePlaceResult(
                                name: name,
                                address: address,
                                latitude: lat,
                                longitude: lng,
                                rating: rating,
                                priceLevel: priceLevel
                            )
                        }
                        
                        // Log individual results
                        for (index, result) in results.enumerated() {
                            print("[\(index + 1)] \(result["name"] as? String ?? "Unknown")")
                        }
                        print("==== END GOOGLE TEXT SEARCH ====\n")
                    }
                } catch {
                    rawResponse = "JSON parsing error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    private func testGoogleAutocomplete() {
        guard googleAPIKey != "YOUR_GOOGLE_API_KEY" else {
            rawResponse = "Error: Please add your Google Places API key to SandboxView.swift"
            return
        }
        
        isSearching = true
        googleResults = []
        rawResponse = ""
        
        let encodedQuery = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(encodedQuery)&location=52.678606347967175,4.698801550831957&radius=5000&key=\(googleAPIKey)"
        
        guard let url = URL(string: urlString) else {
            isSearching = false
            rawResponse = "Error: Invalid URL"
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isSearching = false
                
                if let error = error {
                    rawResponse = "Error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    rawResponse = "Error: No data received"
                    return
                }
                
                // Store raw response
                if let jsonString = String(data: data, encoding: .utf8) {
                    rawResponse = jsonString
                }
                
                // Parse JSON for autocomplete predictions
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let predictions = json["predictions"] as? [[String: Any]] {
                        
                        print("==== GOOGLE AUTOCOMPLETE ====")
                        print("Query: '\(searchText)' | Predictions: \(predictions.count)")
                        
                        // Convert predictions to display format
                        googleResults = predictions.compactMap { prediction in
                            guard let description = prediction["description"] as? String,
                                  let placeId = prediction["place_id"] as? String else {
                                return nil
                            }
                            
                            return GooglePlaceResult(
                                name: description,
                                address: "Place ID: \(placeId)",
                                latitude: 0.0, // Autocomplete doesn't provide coordinates
                                longitude: 0.0,
                                rating: nil,
                                priceLevel: nil
                            )
                        }
                        
                        // Log individual predictions
                        for (index, prediction) in predictions.enumerated() {
                            print("[\(index + 1)] \(prediction["description"] as? String ?? "Unknown")")
                        }
                        print("==== END GOOGLE AUTOCOMPLETE ====\n")
                    }
                } catch {
                    rawResponse = "JSON parsing error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    private func testGooglePlaceDetails() {
        guard googleAPIKey != "YOUR_GOOGLE_API_KEY" else {
            rawResponse = "Error: Please add your Google Places API key to SandboxView.swift"
            return
        }
        
        guard !placeId.isEmpty else {
            rawResponse = "Error: Please enter a Place ID above"
            return
        }
        
        isSearching = true
        googleResults = []
        rawResponse = ""
        
        let urlString = "https://maps.googleapis.com/maps/api/place/details/json?place_id=\(placeId)&fields=name,formatted_address,geometry,rating,price_level,formatted_phone_number,website,opening_hours,photos,reviews&key=\(googleAPIKey)"
        
        guard let url = URL(string: urlString) else {
            isSearching = false
            rawResponse = "Error: Invalid URL"
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isSearching = false
                
                if let error = error {
                    rawResponse = "Error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    rawResponse = "Error: No data received"
                    return
                }
                
                // Store raw response
                if let jsonString = String(data: data, encoding: .utf8) {
                    rawResponse = jsonString
                }
                
                // Parse JSON for place details
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let result = json["result"] as? [String: Any] {
                        
                        print("==== GOOGLE PLACE DETAILS ====")
                        print("Place ID: '\(placeId)'")
                        print("Name: \(result["name"] as? String ?? "Unknown")")
                        
                        // Convert to display format
                        if let name = result["name"] as? String,
                           let address = result["formatted_address"] as? String,
                           let geometry = result["geometry"] as? [String: Any],
                           let location = geometry["location"] as? [String: Any],
                           let lat = location["lat"] as? Double,
                           let lng = location["lng"] as? Double {
                            
                            let rating = result["rating"] as? Double
                            let priceLevel = result["price_level"] as? Int
                            
                            googleResults = [GooglePlaceResult(
                                name: name,
                                address: address,
                                latitude: lat,
                                longitude: lng,
                                rating: rating,
                                priceLevel: priceLevel
                            )]
                        }
                        
                        print("==== END GOOGLE PLACE DETAILS ====\n")
                    }
                } catch {
                    rawResponse = "JSON parsing error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    private func testGoogleNearbySearch() {
        guard googleAPIKey != "YOUR_GOOGLE_API_KEY" else {
            rawResponse = "Error: Please add your Google Places API key to SandboxView.swift"
            return
        }
        
        isSearching = true
        googleResults = []
        rawResponse = ""
        
        let encodedKeyword = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=52.678606347967175,4.698801550831957&radius=5000&keyword=\(encodedKeyword)&key=\(googleAPIKey)"
        
        guard let url = URL(string: urlString) else {
            isSearching = false
            rawResponse = "Error: Invalid URL"
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isSearching = false
                
                if let error = error {
                    rawResponse = "Error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    rawResponse = "Error: No data received"
                    return
                }
                
                // Store raw response
                if let jsonString = String(data: data, encoding: .utf8) {
                    rawResponse = jsonString
                }
                
                // Parse JSON
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let results = json["results"] as? [[String: Any]] {
                        
                        print("==== GOOGLE NEARBY SEARCH ====")
                        print("Keyword: '\(searchText)' | Results: \(results.count)")
                        
                        googleResults = results.compactMap { result in
                            guard let name = result["name"] as? String,
                                  let geometry = result["geometry"] as? [String: Any],
                                  let location = geometry["location"] as? [String: Any],
                                  let lat = location["lat"] as? Double,
                                  let lng = location["lng"] as? Double else {
                                return nil
                            }
                            
                            let address = result["vicinity"] as? String ?? "No address"
                            let rating = result["rating"] as? Double
                            let priceLevel = result["price_level"] as? Int
                            
                            return GooglePlaceResult(
                                name: name,
                                address: address,
                                latitude: lat,
                                longitude: lng,
                                rating: rating,
                                priceLevel: priceLevel
                            )
                        }
                        
                        // Log individual results
                        for (index, result) in results.enumerated() {
                            print("[\(index + 1)] \(result["name"] as? String ?? "Unknown")")
                        }
                        print("==== END GOOGLE NEARBY SEARCH ====\n")
                    }
                } catch {
                    rawResponse = "JSON parsing error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    private func testGooglePlacePhotos() {
        guard googleAPIKey != "YOUR_GOOGLE_API_KEY" else {
            rawResponse = "Error: Please add your Google Places API key to SandboxView.swift"
            return
        }
        
        guard !searchText.isEmpty else {
            rawResponse = "Error: Please enter a photo reference"
            return
        }
        
        isSearching = true
        googleResults = []
        rawResponse = ""
        
        let photoReference = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let urlString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(photoReference)&key=\(googleAPIKey)"
        
        guard let url = URL(string: urlString) else {
            isSearching = false
            rawResponse = "Error: Invalid URL"
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isSearching = false
                
                if let error = error {
                    rawResponse = "Error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    rawResponse = "Error: No data received"
                    return
                }
                
                print("==== GOOGLE PLACE PHOTOS ====")
                print("Photo Reference: '\(photoReference)'")
                print("Response Data Size: \(data.count) bytes")
                
                if let httpResponse = response as? HTTPURLResponse {
                    rawResponse = "Photo API Response:\n"
                    rawResponse += "Status Code: \(httpResponse.statusCode)\n"
                    rawResponse += "Content Type: \(httpResponse.allHeaderFields["Content-Type"] as? String ?? "Unknown")\n"
                    rawResponse += "Data Size: \(data.count) bytes\n"
                    
                    if httpResponse.statusCode == 200 {
                        rawResponse += "\n✅ Photo successfully retrieved!\n"
                        rawResponse += "This would be the actual image data in a real implementation."
                    } else {
                        rawResponse += "\n❌ Error retrieving photo"
                    }
                } else {
                    rawResponse = "Photo data received: \(data.count) bytes"
                }
                
                print("==== END GOOGLE PLACE PHOTOS ====\n")
            }
        }.resume()
    }
    
    private func debounceSearch() {
        // Cancel previous timer
        searchTimer?.invalidate()
        
        // Clear results if text is empty
        if searchText.isEmpty {
            searchResults = []
            googleResults = []
            rawResponse = ""
            return
        }
        
        // Create new timer with 0.5 second delay
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            DispatchQueue.main.async {
                if selectedProvider == .apple {
                    testAppleMapKit()
                } else {
                    testSelectedGoogleEndpoint()
                }
            }
        }
    }
}

#Preview {
    SandboxView()
}
