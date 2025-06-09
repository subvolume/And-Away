import SwiftUI

// MARK: - Place Type Helpers
struct PlaceTypeHelpers {
    
    // MARK: - Icon Helper
    static func iconForPlaceType(_ types: [String]) -> Image {
        // Convert all types to lowercase for flexible matching
        let lowercaseTypes = types.map { $0.lowercased() }
        
        if lowercaseTypes.contains(where: { $0.contains("restaurant") || $0.contains("food") }) {
            return Image(systemName: "fork.knife")
        } else if lowercaseTypes.contains(where: { $0.contains("cafe") || $0.contains("coffee") }) {
            return Image(systemName: "cup.and.saucer.fill")
        } else if lowercaseTypes.contains(where: { $0.contains("tourist") || $0.contains("attraction") }) {
            return Image(systemName: "camera.fill")
        } else if lowercaseTypes.contains(where: { $0.contains("museum") }) {
            return Image(systemName: "building.columns")
        } else if lowercaseTypes.contains(where: { $0.contains("store") || $0.contains("shop") || $0.contains("shopping") }) {
            return Image(systemName: "bag.fill")
        } else {
            return Image(systemName: "mappin")
        }
    }
    
    // MARK: - Color Helper
    static func colorForPlaceType(_ types: [String]) -> Color {
        if types.contains("restaurant") || types.contains("food") {
            return .orange100
        } else if types.contains("cafe") {
            return .teal100
        } else if types.contains("tourist_attraction") {
            return .azure100
        } else if types.contains("museum") {
            return .purple100
        } else if types.contains("store") || types.contains("shopping_mall") {
            return .red100
        } else {
            return .green100
        }
    }
}

#Preview {
    // Helper function to create place type artwork
    func placeArtwork(for types: [String]) -> ArtworkView {
        ArtworkView(artwork: .circleIcon(
            color: PlaceTypeHelpers.colorForPlaceType(types),
            icon: PlaceTypeHelpers.iconForPlaceType(types)
        ))
    }
    
    return VStack(spacing: 16) {
        // ArtworkView components (as used in search results)
        HStack(spacing: 12) {
            placeArtwork(for: ["restaurant"])
            placeArtwork(for: ["cafe"])
            placeArtwork(for: ["tourist_attraction"])
            placeArtwork(for: ["museum"])
            placeArtwork(for: ["store"])
        }
        
        // MapPOI components (as used on map)
        HStack(spacing: 12) {
            MapPOI(types: ["restaurant"], onTap: {})
            MapPOI(types: ["cafe"], onTap: {})
            MapPOI(types: ["tourist_attraction"], onTap: {})
            MapPOI(types: ["museum"], onTap: {})
            MapPOI(types: ["store"], onTap: {})
        }
    }
    .padding()
} 
