import SwiftUI

struct PlaceDetailsView: View {
    let onBackTapped: () -> Void
    
    // Using mock data from MockData.swift
    private let placeDetails = MockData.samplePlaceDetails.result
    
    var body: some View {
        VStack(spacing: 0) {
            // Use existing SheetHeader component with place name from mock data
            SheetHeader(title: placeDetails.name, onClose: onBackTapped)
            PlaceDetailsActions()

            
            ScrollView {
                VStack(spacing: Spacing.xs) {
                   // ImageCarouselView()
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
