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
            return Image(systemName: "cup.and.saucer")
        } else if lowercaseTypes.contains(where: { $0.contains("tourist") || $0.contains("attraction") }) {
            return Image(systemName: "camera")
        } else if lowercaseTypes.contains(where: { $0.contains("museum") }) {
            return Image(systemName: "building.columns")
        } else if lowercaseTypes.contains(where: { $0.contains("store") || $0.contains("shop") || $0.contains("shopping") }) {
            return Image(systemName: "bag.fill")
        } else {
            return Image(systemName: "mappin.circle")
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
    VStack(spacing: 16) {
        // ArtworkView components (as used in search results)
        HStack(spacing: 12) {
            ArtworkView(artwork: .circleIcon(color: PlaceTypeHelpers.colorForPlaceType(["restaurant"]), icon: PlaceTypeHelpers.iconForPlaceType(["restaurant"])))
            ArtworkView(artwork: .circleIcon(color: PlaceTypeHelpers.colorForPlaceType(["cafe"]), icon: PlaceTypeHelpers.iconForPlaceType(["cafe"])))
            ArtworkView(artwork: .circleIcon(color: PlaceTypeHelpers.colorForPlaceType(["tourist_attraction"]), icon: PlaceTypeHelpers.iconForPlaceType(["tourist_attraction"])))
            ArtworkView(artwork: .circleIcon(color: PlaceTypeHelpers.colorForPlaceType(["museum"]), icon: PlaceTypeHelpers.iconForPlaceType(["museum"])))
            ArtworkView(artwork: .circleIcon(color: PlaceTypeHelpers.colorForPlaceType(["store"]), icon: PlaceTypeHelpers.iconForPlaceType(["store"])))
        }
        
        // MapPOI components (as used on map)
        HStack(spacing: 12) {
            MapPOI(place: PlaceSearchResult(placeId: "1", name: "Restaurant", vicinity: nil, formattedAddress: nil, addressComponents: nil, rating: nil, priceLevel: nil, photos: nil, geometry: PlaceGeometry(location: PlaceLocation(lat: 0.0, lng: 0.0), viewport: nil), types: ["restaurant"], userRatingsTotal: nil, businessStatus: nil), onTap: {})
            MapPOI(place: PlaceSearchResult(placeId: "2", name: "Cafe", vicinity: nil, formattedAddress: nil, addressComponents: nil, rating: nil, priceLevel: nil, photos: nil, geometry: PlaceGeometry(location: PlaceLocation(lat: 0.0, lng: 0.0), viewport: nil), types: ["cafe"], userRatingsTotal: nil, businessStatus: nil), onTap: {})
            MapPOI(place: PlaceSearchResult(placeId: "3", name: "Attraction", vicinity: nil, formattedAddress: nil, addressComponents: nil, rating: nil, priceLevel: nil, photos: nil, geometry: PlaceGeometry(location: PlaceLocation(lat: 0.0, lng: 0.0), viewport: nil), types: ["tourist_attraction"], userRatingsTotal: nil, businessStatus: nil), onTap: {})
            MapPOI(place: PlaceSearchResult(placeId: "4", name: "Museum", vicinity: nil, formattedAddress: nil, addressComponents: nil, rating: nil, priceLevel: nil, photos: nil, geometry: PlaceGeometry(location: PlaceLocation(lat: 0.0, lng: 0.0), viewport: nil), types: ["museum"], userRatingsTotal: nil, businessStatus: nil), onTap: {})
            MapPOI(place: PlaceSearchResult(placeId: "5", name: "Store", vicinity: nil, formattedAddress: nil, addressComponents: nil, rating: nil, priceLevel: nil, photos: nil, geometry: PlaceGeometry(location: PlaceLocation(lat: 0.0, lng: 0.0), viewport: nil), types: ["store"], userRatingsTotal: nil, businessStatus: nil), onTap: {})
        }
    }
    .padding()
} 
