import SwiftUI

struct MapPOI: View {
    let place: PlaceSearchResult
    let onTap: (() -> Void)?
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            iconForPlaceType(place.types)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color.white100)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .padding(3)
        .frame(width: 22, height: 22, alignment: .center)
        .background(colorForPlaceType(place.types))
        .cornerRadius(11)
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
        .overlay(
          RoundedRectangle(cornerRadius: 11)
            .inset(by: -1)
            .stroke(Color.white100, lineWidth: 2)
        )
        .onTapGesture {
            onTap?()
        }
    }
    
    // Helper function to get appropriate icon based on place type
    private func iconForPlaceType(_ types: [String]) -> Image {
        if types.contains("restaurant") || types.contains("food") {
            return Image(systemName: "fork.knife")
        } else if types.contains("cafe") {
            return Image(systemName: "cup.and.saucer")
        } else if types.contains("tourist_attraction") {
            return Image(systemName: "camera")
        } else if types.contains("museum") {
            return Image(systemName: "building.columns")
        } else {
            return Image(systemName: "mappin.circle")
        }
    }
    
    // Helper function to get appropriate color based on place type
    private func colorForPlaceType(_ types: [String]) -> Color {
        if types.contains("restaurant") || types.contains("food") {
            return .orange100
        } else if types.contains("cafe") {
            return .teal100
        } else if types.contains("tourist_attraction") {
            return .azure100
        } else if types.contains("museum") {
            return .purple100
        } else {
            return .green100
        }
    }
}

#Preview {
    // Create a sample place for preview
    let samplePlace = PlaceSearchResult(
        placeId: "sample-id",
        name: "Sample Restaurant",
        vicinity: nil,
        formattedAddress: nil,
        addressComponents: nil,
        rating: nil,
        priceLevel: nil,
        photos: nil,
        geometry: PlaceGeometry(
            location: PlaceLocation(lat: 0.0, lng: 0.0),
            viewport: nil
        ),
        types: ["restaurant"],
        userRatingsTotal: nil,
        businessStatus: nil
    )
    
    return MapPOI(place: samplePlace, onTap: {
        print("POI tapped!")
    })
} 