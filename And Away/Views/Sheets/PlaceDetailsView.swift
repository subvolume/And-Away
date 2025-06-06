import SwiftUI

struct PlaceDetailsView: View {
    let onBackTapped: () -> Void
    @State private var selectedDetent: PresentationDetent = .medium
    
    // Using mock data from MockData.swift
    private let placeDetails = MockData.samplePlaceDetails.result
    
    var body: some View {
        VStack(spacing: 0) {
            // Use existing SheetHeader component with place name from mock data
            SheetHeader(title: placeDetails.name, onClose: onBackTapped)
            PlaceDetailsActions()

            
            ScrollView {
                VStack(spacing: Spacing.xs) {
                    ImageCarouselView()
                }
            }
        }
        .presentationDetents([.height(100), .medium, .fraction(0.99)], selection: $selectedDetent)
        .presentationBackgroundInteraction(.enabled)
        .interactiveDismissDisabled()
    }
}

#Preview {
    PlaceDetailsView(onBackTapped: {
        print("Back tapped")
    })
} 
