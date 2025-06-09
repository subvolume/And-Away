import SwiftUI

struct PlaceDetailsActions: View {
    // MARK: - Properties
    let placeId: String
    let placeDetails: PlaceDetails?
    let placeSearchResult: PlaceSearchResult?
    
    // MARK: - State
    @StateObject private var bookmarkManager = BookmarkManager.shared
    @State private var isTodaySelected = false
    
    // MARK: - Computed Properties
    private var isBookmarked: Bool {
        bookmarkManager.isBookmarked(placeId: placeId)
    }
    
    // MARK: - Initializers
    init(placeDetails: PlaceDetails) {
        self.placeId = placeDetails.placeId
        self.placeDetails = placeDetails
        self.placeSearchResult = nil
    }
    
    init(placeSearchResult: PlaceSearchResult) {
        self.placeId = placeSearchResult.placeId
        self.placeDetails = nil
        self.placeSearchResult = placeSearchResult
    }
    
    var body: some View {
        HStack {
            // Bookmark Button - now with real functionality
            PillButton(
                icon: "bookmark.fill", 
                isSelected: isBookmarked
            ) {
                toggleBookmark()
            }
            
            PillButton(text: isTodaySelected ? "Today!" : "Today?", icon: isTodaySelected ? "checkmark" : "plus", isSelected: isTodaySelected) {
                isTodaySelected.toggle()
            }
            
            PillButton(icon: "message.fill") {
                // Chat action - prepared for AI integration
            }
            
            PillButton(icon: "ellipsis") {
                // Menu action - could show notes editing, visit status, etc.
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
    // MARK: - Private Functions
    private func toggleBookmark() {
        if isBookmarked {
            // Unbookmark
            bookmarkManager.unbookmark(placeId: placeId)
        } else {
            // Bookmark
            if let placeDetails = placeDetails {
                bookmarkManager.bookmark(placeDetails: placeDetails, context: .manual)
            } else if let placeSearchResult = placeSearchResult {
                bookmarkManager.bookmark(place: placeSearchResult, context: .manual)
            }
        }
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
}

#Preview {
    // Create a mock PlaceDetails for preview
    let mockPlaceDetails = PlaceDetails(
        placeId: "preview_place_id",
        name: "Preview Restaurant",
        formattedAddress: "123 Preview Street, Preview City",
        addressComponents: nil,
        formattedPhoneNumber: nil,
        internationalPhoneNumber: nil,
        website: nil,
        rating: 4.5,
        userRatingsTotal: 150,
        priceLevel: nil,
        photos: nil,
        reviews: nil,
        openingHours: nil,
        geometry: PlaceGeometry(
            location: PlaceLocation(lat: 40.7128, lng: -74.0060),
            viewport: nil
        ),
        types: ["restaurant", "food"],
        businessStatus: nil,
        utcOffset: nil
    )
    
    PlaceDetailsActions(placeDetails: mockPlaceDetails)
} 
