import SwiftUI

struct PlaceDetailsView: View {
    let placeId: String
    let onBackTapped: () -> Void
    
    // TODO: In Phase 5, this will fetch real place details using GooglePlacesSwift
    // For now, use sample data for Phase 4.5 verification
    private var place: Place {
        return Place.sample
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Use existing SheetHeader component with place name from our unified Place model
                SheetHeader(title: place.name, onClose: onBackTapped)
                
                ScrollView {
                    VStack(spacing: Spacing.l) {
                        ImageCarouselView()
                        
                        // TODO: Phase 5 - Add real place details display:
                        // - Address information
                        // - Rating and reviews
                        // - Business hours
                        // - Contact information
                        // - Real photos from GooglePlacesSwift
                        
                        Text("Place details will be implemented in Phase 5")
                            .font(.caption)
                            .foregroundColor(.grey100)
                            .padding()
                    }
                }
            }
            .frame(width: geometry.size.width)
        }
    }
}

#Preview {
    PlaceDetailsView(placeId: "ChIJL-ROikVu5kcRzWBvNS3lnM0", onBackTapped: {
        print("Back tapped")
    })
} 
