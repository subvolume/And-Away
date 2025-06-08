import SwiftUI

struct PlaceDetailsView: View {
    let onBackTapped: () -> Void
    
    // Using mock data from MockData.swift
    private let placeDetails = MockData.samplePlaceDetails.result
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Use existing SheetHeader component with place name from mock data
                SheetHeader(title: placeDetails.name, onClose: onBackTapped)
                
                ScrollView {
                    VStack(spacing: Spacing.xs) {
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
    PlaceDetailsView(onBackTapped: {
        print("Back tapped")
    })
} 
