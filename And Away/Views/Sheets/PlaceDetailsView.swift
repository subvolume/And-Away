import SwiftUI

struct PlaceDetailsView: View {
    let placeId: String
    let onBackTapped: () -> Void
    
    // Look up place details from MockData using the placeId, with fallback to sample data
    private var placeDetails: PlaceDetails {
        return MockData.allPlaceDetails[placeId] ?? MockData.samplePlaceDetails.result
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Use existing SheetHeader component with place name from selected place
                SheetHeader(title: placeDetails.name, onClose: onBackTapped)
                
                ScrollView {
                    VStack(spacing: Spacing.l) {
                        PlaceDetailsActions()
                        ImageCarouselView()
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
