import SwiftUI

struct PlacesServiceSandbox: View {
    @StateObject private var placesService = GooglePlacesService()
    @StateObject private var locationManager = LocationManager.shared
    
    @State private var searchText = "coffee"
    @State private var searchResults: [Place] = []
    @State private var showingLocationAlert = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Google Places SDK Sandbox")
                .font(.title)
                .padding()
            
            // Location Status
            HStack {
                Image(systemName: locationStatusIcon)
                    .foregroundColor(locationStatusColor)
                Text(locationStatusText)
                    .font(.caption)
                
                if locationManager.shouldShowSettingsAlert {
                    Button("Settings") {
                        showingLocationAlert = true
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            
            // Search Section
            VStack(alignment: .leading, spacing: 10) {
                Text("Text Search with SDK")
                    .font(.headline)
                
                HStack {
                    TextField("Search for places", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            performSearch()
                        }
                    
                    Button("Search") {
                        performSearch()
                    }
                    .disabled(placesService.isLoading)
                }
                
                if placesService.isLoading {
                    ProgressView("Searching with SDK...")
                        .frame(maxWidth: .infinity)
                }
                
                // Error Display
                if let error = placesService.lastError {
                    Text("Error: \(error.localizedDescription)")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.vertical, 4)
                }
                
                // Results Display
                if !searchResults.isEmpty {
                    Text("SDK Results (\(searchResults.count)):")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(searchResults) { place in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(place.name)
                                        .font(.body)
                                        .fontWeight(.medium)
                                    
                                    Text(place.address.fullAddress)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    HStack {
                                        Text("Lat: \(place.location.latitude, specifier: "%.4f"), Lng: \(place.location.longitude, specifier: "%.4f")")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        
                                        if let rating = place.details.rating {
                                            Text("★ \(rating, specifier: "%.1f")")
                                                .font(.caption)
                                                .foregroundColor(.orange)
                                        }
                                    }
                                    
                                    Text("Category: \(place.category.displayName)")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                    
                                    if let userLocation = locationManager.currentCoordinate {
                                        Text("Distance: \(place.distanceText(from: userLocation))")
                                            .font(.caption)
                                            .foregroundColor(.green)
                                    }
                                }
                                .padding(.vertical, 4)
                                Divider()
                            }
                        }
                    }
                    .frame(maxHeight: 300)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            Spacer()
        }
        .padding()
        .onAppear {
            locationManager.requestLocationPermission()
        }
        .alert("Location Access", isPresented: $showingLocationAlert) {
            Button("Settings") {
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Please enable location access in Settings to get better search results based on your location.")
        }
    }
    
    private func performSearch() {
        Task {
            do {
                let results = try await placesService.search(
                    text: searchText,
                    userLocation: locationManager.currentCoordinate
                )
                await MainActor.run {
                    searchResults = results
                }
            } catch {
                print("Search failed: \(error)")
            }
        }
    }
    
    private var locationStatusIcon: String {
        switch locationManager.authorizationStatus {
        case .notDetermined: return "location.circle"
        case .denied, .restricted: return "location.slash"
        case .authorizedWhenInUse, .authorizedAlways: return "location.fill"
        @unknown default: return "location.circle"
        }
    }
    
    private var locationStatusColor: Color {
        switch locationManager.authorizationStatus {
        case .notDetermined: return .orange
        case .denied, .restricted: return .red
        case .authorizedWhenInUse, .authorizedAlways: return .green
        @unknown default: return .gray
        }
    }
    
    private var locationStatusText: String {
        switch locationManager.authorizationStatus {
        case .notDetermined: return "Location permission pending"
        case .denied, .restricted: return "Location access denied"
        case .authorizedWhenInUse, .authorizedAlways:
            if let location = locationManager.currentLocation {
                return String(format: "Location: %.3f, %.3f", location.coordinate.latitude, location.coordinate.longitude)
            } else {
                return "Getting location..."
            }
        @unknown default: return "Location unknown"
        }
    }
}

#Preview {
    PlacesServiceSandbox()
} 