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

struct SandboxView: View {
    @State private var searchResults: [MKMapItem] = []
    @State private var googleResults: [GooglePlaceResult] = []
    @State private var isSearching = false
    @State private var searchText = ""
    @State private var selectedProvider: SearchProvider = .apple
    @State private var showRawResponse = false
    @State private var rawResponse = ""
    @State private var searchAsYouType = false
    @State private var searchTimer: Timer?
    
    // Add your Google Places API key here
    private let googleAPIKey = "AIzaSyDuKI9Sn6gMj6yN8WUz4_TgeO1gjEo479E" // Replace with your actual key
    
    var body: some View {
        VStack(spacing: 20) {
            Text("API Testing Sandbox")
                .font(.title)
                .padding()
            
            // Provider Selection
            Picker("API Provider", selection: $selectedProvider) {
                Text("Apple MapKit").tag(SearchProvider.apple)
                Text("Google Places").tag(SearchProvider.google)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            // Search Section
            VStack(alignment: .leading, spacing: 10) {
                Text("\(selectedProvider == .apple ? "Apple MapKit" : "Google Places") Search Test")
                    .font(.headline)
                
                HStack {
                    TextField("Search for places", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: searchText) { _ in
                            if searchAsYouType {
                                debounceSearch()
                            }
                        }
                    
                    Button("Search") {
                        if selectedProvider == .apple {
                            testAppleMapKit()
                        } else {
                            testGooglePlaces()
                        }
                    }
                    .disabled(isSearching)
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
                    .frame(maxHeight: 200)
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
                    .frame(maxHeight: 200)
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
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // San Francisco
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
    
    private func testGooglePlaces() {
        guard googleAPIKey != "YOUR_GOOGLE_API_KEY" else {
            rawResponse = "Error: Please add your Google Places API key to SandboxView.swift"
            return
        }
        
        isSearching = true
        googleResults = []
        rawResponse = ""
        
        let encodedQuery = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(encodedQuery)&location=37.7749,-122.4194&radius=5000&key=\(googleAPIKey)"
        
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
                        print("==== GOOGLE PLACES ====")
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
                        print("==== END GOOGLE ====\n")
                    }
                } catch {
                    rawResponse = "JSON parsing error: \(error.localizedDescription)"
                }
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
                    testGooglePlaces()
                }
            }
        }
    }
}

#Preview {
    SandboxView()
}
