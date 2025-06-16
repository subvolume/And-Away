import SwiftUI

struct PlaceDetailsView: View {
    let place: Place
    let onBackTapped: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Use existing SheetHeader component with place name from selected place
                SheetHeader(title: place.name, onClose: onBackTapped)
                
                ScrollView {
                    VStack(spacing: Spacing.l) {
                        ImageCarouselView()
                    }
                }
            }
            .frame(width: geometry.size.width)
        }
    }
}

#Preview {
    PlaceDetailsView(place: MockPlacesData.samplePlaces[0], onBackTapped: {
        print("Back tapped")
    })
} 
