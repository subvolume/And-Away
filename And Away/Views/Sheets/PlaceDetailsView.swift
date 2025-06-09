import SwiftUI

struct PlaceDetailsView: View {
    let placeId: String
    let onBackTapped: () -> Void
    
    @State private var placeDetails: PlaceDetails?
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    private let googleAPI = GoogleAPIService.shared
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Show loading or place name with real info
                if let place = placeDetails {
                    SheetHeader(
                        title: place.name,
                        placeType: getPlaceType(from: place.types),
                        openStatus: getOpenStatus(from: place.openingHours),
                        isOpen: place.openingHours?.openNow,
                        onClose: onBackTapped
                    )
                } else {
                    SheetHeader(
                        title: "Loading...",
                        placeType: nil,
                        openStatus: nil,
                        isOpen: nil,
                        onClose: onBackTapped
                    )
                }
                
                // Main content area
                if isLoading {
                    // Loading state
                    VStack(spacing: 16) {
                        Spacer()
                        ProgressView()
                            .scaleEffect(1.2)
                        Text("Loading place details...")
                            .font(.body)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    
                } else if let errorMessage = errorMessage {
                    // Error state
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 48))
                            .foregroundColor(.orange)
                        Text("Error")
                            .font(.title2)
                            .fontWeight(.medium)
                        Text(errorMessage)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .padding()
                    
                } else if let place = placeDetails {
                    // Success state - show simple place details
                    ScrollView {
                        VStack(spacing: Spacing.l) {
                            PlaceDetailsActions()
                            ImageCarouselView(imageURLs: getPhotoURLs(from: place.photos))
                            PlaceDetailsTravel(
                                place: place,
                                userLocation: "Current Location"
                            )
                        }
                    }
                }
            }
            .frame(width: geometry.size.width)
        }
        .onAppear {
            loadPlaceDetails()
        }
    }
    
    // MARK: - Load Real Place Details
    private func loadPlaceDetails() {
        Task {
            do {
                let response = try await googleAPI.getPlaceDetails(placeId: placeId)
                await MainActor.run {
                    self.placeDetails = response.result
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to load place details: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    private func getPlaceType(from types: [String]) -> String? {
        for type in types {
            switch type {
            case "restaurant": return "Restaurant"
            case "cafe": return "Cafe"
            case "tourist_attraction": return "Attraction"
            case "museum": return "Museum"
            case "store": return "Store"
            case "lodging": return "Hotel"
            default: continue
            }
        }
        return types.first?.replacingOccurrences(of: "_", with: " ").capitalized
    }
    
    private func getOpenStatus(from openingHours: OpeningHours?) -> String? {
        guard let openingHours = openingHours,
              let isOpen = openingHours.openNow else {
            return nil
        }
        return isOpen ? "Open" : "Closed"
    }
    
    private func getPhotoURLs(from photos: [PlacePhoto]?) -> [URL] {
        guard let photos = photos else { return [] }
        
        // Get up to 8 photos
        return photos.prefix(8).compactMap { photo in
            googleAPI.getPhotoURL(photoReference: photo.photoReference, maxWidth: 400)
        }
    }
}

#Preview {
    PlaceDetailsView(placeId: "ChIJL-ROikVu5kcRzWBvNS3lnM0", onBackTapped: {
        print("Back tapped")
    })
} 
