import SwiftUI
import GooglePlacesSwift

struct PlaceDetailsView: View {
    let placeId: String
    let placeName: String?
    let onBackTapped: () -> Void
    
    @State private var place: Place?
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var isSearchActive = false
    
    private let placesService = GooglePlacesService()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
            // Get category information if place is available
            let categoryInfo: (name: String, icon: Image, color: Color)? = {
                if let place = place {
                    let googleTypes = place.types.map { $0.rawValue }
                    let info = CategoryStyle.category(for: googleTypes)
                    return (info.subcategory.rawValue, info.icon, info.color)
                }
                return nil
            }()
            
            SheetHeader(
                title: placeName ?? place?.displayName ?? "Place Details",
                categoryName: categoryInfo?.name,
                categoryIcon: categoryInfo?.icon,
                categoryColor: categoryInfo?.color
            )
            
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
                        // Types/Categories
                        if !place.types.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Category")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                // Log types for debugging
                                let _ = print("Place Details - Types: \(place.types.map { $0.rawValue })")
                                
                                // Use CategoryStyle to get formatted category name
                                let googleTypes = place.types.map { $0.rawValue }
                                let categoryName = CategoryStyle.formattedCategoryName(for: googleTypes)
                                
                                Text(categoryName)
                                    .foregroundColor(.secondary)
                            }
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
                        
                        Spacer(minLength: 100) // Increased to account for ActionBar
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
        ActionBar(isSearchActive: $isSearchActive, configuration: .placeDetails, onClose: onBackTapped)
            .frame(maxWidth: .infinity)
    }
    .ignoresSafeArea(.container, edges: .bottom)
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
    PlaceDetailsView(placeId: "sample-place-id", placeName: nil, onBackTapped: {})
} 
