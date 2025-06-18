import SwiftUI

struct PlaceDetailsView: View {
    let placeId: String
    let onBackTapped: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Use existing SheetHeader component with placeholder
                SheetHeader(title: "Place Details", onClose: onBackTapped)
                
                ScrollView {
                    VStack(spacing: Spacing.l) {
                        Text("Place ID: \(placeId)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("GooglePlacesService integration pending")
                            .foregroundColor(.secondary)
                        
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
