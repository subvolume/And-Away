import SwiftUI

struct GooglePlacesServiceTest: View {
    @State private var results: [GooglePlace] = []
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var searchText = "coffee"
    @State private var searchAsYouType = true
    @State private var searchTimer: Timer?
    
    // API key now loaded securely from Config
    private let apiKey = Config.googlePlacesAPIKey
    
    var body: some View {
        VStack(spacing: 20) {
            Text("GooglePlacesService Test")
                .font(.headline)
            
            TextField("Search query", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .onChange(of: searchText) {
                    if searchAsYouType {
                        performSearch()
                    }
                }
            
            HStack {
                Toggle("Search as you type", isOn: $searchAsYouType)
                    .font(.caption)
                
                Spacer()
                
                Button("Search") {
                    performManualSearch()
                }
                .disabled(isLoading)
            }
            
            if isLoading {
                ProgressView("Searching...")
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
    
    private func performSearch() {
        // Cancel previous search
        searchTimer?.invalidate()
        
        // Clear results if text is empty
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            results = []
            isLoading = false
            errorMessage = ""
            return
        }
        
        // Show loading immediately
        isLoading = true
        errorMessage = ""
        
        // Debounce with 0.5 second delay
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            Task {
                await executeSearch()
            }
        }
    }
    
    @MainActor
    private func executeSearch() async {
        let service = GooglePlacesService(apiKey: apiKey)
        
        do {
            let places = try await service.smartSearch(query: searchText)
            results = places
            isLoading = false
            print("✅ Smart Search Success: \(places.count) results for '\(searchText)'")
        } catch {
            errorMessage = error.localizedDescription
            results = []
            isLoading = false
            print("❌ Smart Search Error: \(error)")
        }
    }
    
    private func performManualSearch() {
        guard !searchText.isEmpty else { return }
        
        isLoading = true
        errorMessage = ""
        results = []
        
        let service = GooglePlacesService(apiKey: apiKey)
        
        Task {
            do {
                let places = try await service.smartSearch(query: searchText)
                await MainActor.run {
                    results = places
                    isLoading = false
                    print("✅ Manual Smart Search Success: \(places.count) results")
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isLoading = false
                    print("❌ Manual Smart Search Error: \(error)")
                }
            }
        }
    }
}

#Preview {
    GooglePlacesServiceTest()
} 