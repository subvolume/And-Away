import SwiftUI

struct GooglePlacesServiceTest: View {
    @State private var results: [GooglePlace] = []
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var searchText = "coffee"
    
    // Add your API key here
    private let apiKey = "AIzaSyDuKI9Sn6gMj6yN8WUz4_TgeO1gjEo479E"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("GooglePlacesService Test")
                .font(.headline)
            
            TextField("Search query", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            HStack {
                Button("Test Autocomplete") {
                    testAutocomplete()
                }
                .disabled(isLoading)
                
                Button("Test Text Search") {
                    testTextSearch()
                }
                .disabled(isLoading)
            }
            
            if isLoading {
                ProgressView("Testing...")
            }
            
            if !errorMessage.isEmpty {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            }
            
            if !results.isEmpty {
                Text("Results (\(results.count)):")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                List(results) { place in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(place.name)
                            .font(.body)
                            .fontWeight(.medium)
                        
                        if let vicinity = place.vicinity {
                            Text(vicinity)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Text("Types: \(place.types.joined(separator: ", "))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if let location = place.location {
                            Text("GPS: \(location.lat, specifier: "%.4f"), \(location.lng, specifier: "%.4f")")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 2)
                }
            }
            
            Spacer()
        }
        .padding()
    }
    
    private func testAutocomplete() {
        guard !searchText.isEmpty else { return }
        
        isLoading = true
        errorMessage = ""
        results = []
        
        let service = GooglePlacesService(apiKey: apiKey)
        
        Task {
            do {
                let places = try await service.autocomplete(query: searchText)
                await MainActor.run {
                    results = places
                    isLoading = false
                    print("✅ Autocomplete Success: \(places.count) results")
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isLoading = false
                    print("❌ Autocomplete Error: \(error)")
                }
            }
        }
    }
    
    private func testTextSearch() {
        guard !searchText.isEmpty else { return }
        
        isLoading = true
        errorMessage = ""
        results = []
        
        let service = GooglePlacesService(apiKey: apiKey)
        
        Task {
            do {
                let places = try await service.textSearch(query: searchText)
                await MainActor.run {
                    results = places
                    isLoading = false
                    print("✅ Text Search Success: \(places.count) results")
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isLoading = false
                    print("❌ Text Search Error: \(error)")
                }
            }
        }
    }
}

#Preview {
    GooglePlacesServiceTest()
} 