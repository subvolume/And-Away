import SwiftUI
import GooglePlacesSwift

struct PlaceDetailsView: View {
    let placeId: String
    let onBackTapped: () -> Void
    
    @State private var place: Place?
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    private let placesService = GooglePlacesService()
    
    var body: some View {
        VStack(spacing: 0) {
            SheetHeader(title: "Place Details", onClose: onBackTapped)
            
            ScrollView {
                if isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .padding()
                        Text("Loading place details...")
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                } else if let errorMessage = errorMessage {
                    VStack(spacing: 16) {
                        Text("Error Loading Place")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(errorMessage)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 40)
                } else if let place = place {
                    // Display real place information
                    VStack(alignment: .leading, spacing: 20) {
                        // Place name
                        if let displayName = place.displayName {
                            Text(displayName)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.horizontal)
                        }
                        
                        // Address
                        if let formattedAddress = place.formattedAddress {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Address")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text(formattedAddress)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal)
                        }
                        
                        // Rating
                        if let rating = place.rating {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Rating")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                HStack {
                                    Text(String(format: "%.1f", rating))
                                        .fontWeight(.medium)
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                        .font(.caption)
                                    if place.numberOfUserRatings > 0 {
                                        Text("(\(place.numberOfUserRatings) reviews)")
                                            .foregroundColor(.secondary)
                                            .font(.caption)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Phone number
                        if let phoneNumber = place.internationalPhoneNumber {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Phone")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text(phoneNumber)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal)
                        }
                        
                        // Website
                        if let websiteURL = place.websiteURL {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Website")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text(websiteURL.absoluteString)
                                    .foregroundColor(.blue)
                            }
                            .padding(.horizontal)
                        }
                        
                        // Coordinates (for debugging)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Location")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text("Lat: \(place.location.latitude), Lng: \(place.location.longitude)")
                                .font(.caption)
                                .foregroundColor(.tertiary)
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.top, 20)
                } else {
                    VStack(spacing: 16) {
                        Text("Place not found")
                            .foregroundColor(.secondary)
                            .padding()
                    }
                    .padding(.top, 40)
                }
            }
        }
        .onAppear {
            fetchPlaceDetails()
        }
    }
    
    private func fetchPlaceDetails() {
        isLoading = true
        errorMessage = nil
        
        Task {
            let result = await placesService.fetchPlace(placeID: placeId)
            
            await MainActor.run {
                isLoading = false
                
                switch result {
                case .success(let fetchedPlace):
                    place = fetchedPlace
                case .failure(let error):
                    place = nil
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    PlaceDetailsView(placeId: "sample-place-id", onBackTapped: {})
} 
