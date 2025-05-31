import SwiftUI

struct PlaceDetailsView: View {
    let onBackTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Use existing SheetHeader component instead of custom back button
            SheetHeader(title: "Place Details", onClose: onBackTapped)
            PlaceDetailsActions()

            
            ScrollView {
                VStack(spacing: Spacing.xs) {
                    ImageCarouselView()
                }
            }
        }
    }
}

#Preview {
    PlaceDetailsView(onBackTapped: {
        print("Back tapped")
    })
} 