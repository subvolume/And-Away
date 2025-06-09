import SwiftUI

// MARK: - Place Visual Styling
struct PlaceVisuals {
    
    /// Get icon for place category
    static func icon(for category: PlaceCategory) -> Image {
        return Image(systemName: iconName(for: category))
    }
    
    /// Get color for place category
    static func color(for category: PlaceCategory) -> Color {
        switch category {
        case .restaurant: return .sky100
        case .cafe: return .teal100
        case .attraction: return .azure100
        case .shopping: return .red100
        case .accommodation: return .blue100
        case .transport: return .green100
        case .health: return .aqua100
        case .entertainment: return .lilac100
        case .services: return .grey100
        case .other: return .yellow100
        }
    }
    
    /// Get system icon name for place category
    static func iconName(for category: PlaceCategory) -> String {
        switch category {
        case .restaurant: return "shippingbox.fill"
        case .cafe: return "cup.and.saucer.fill"
        case .attraction: return "camera.fill"
        case .shopping: return "bag.fill"
        case .accommodation: return "bed.double"
        case .transport: return "car.fill"
        case .health: return "cross.fill"
        case .entertainment: return "gamecontroller.fill"
        case .services: return "wrench.and.screwdriver.fill"
        case .other: return "mappin"
        }
    }
}

// MARK: - Convenience Extensions
extension PlaceCategory {
    
    /// Convenience property for getting icon
    var icon: Image {
        return PlaceVisuals.icon(for: self)
    }
    
    /// Convenience property for getting color
    var color: Color {
        return PlaceVisuals.color(for: self)
    }
    
    /// Convenience property for getting icon name
    var iconName: String {
        return PlaceVisuals.iconName(for: self)
    }
}

#Preview {
    VStack(spacing: 20) {
        Text("Place Visual Styling")
            .font(.headline)
        
        Text("All place categories with their visual styling")
            .font(.caption)
            .foregroundColor(.secondary)
        
        Divider()
        
        // ArtworkView showcase (used in lists)
        VStack(spacing: 8) {
            Text("List Items (ArtworkView)")
                .font(.subheadline)
                .fontWeight(.medium)
            
            HStack(spacing: 12) {
                ForEach([PlaceCategory.restaurant, .cafe, .attraction, .shopping, .accommodation], id: \.self) { category in
                    VStack(spacing: 4) {
                        ArtworkView(artwork: .circleIcon(
                            color: PlaceVisuals.color(for: category),
                            icon: PlaceVisuals.icon(for: category)
                        ))
                        Text(category.displayName)
                            .font(.caption2)
                    }
                }
            }
            HStack(spacing: 12) {
                ForEach([PlaceCategory.transport, .health, .entertainment, .services, .other], id: \.self) { category in
                    VStack(spacing: 4) {
                        ArtworkView(artwork: .circleIcon(
                            color: PlaceVisuals.color(for: category),
                            icon: PlaceVisuals.icon(for: category)
                        ))
                        Text(category.displayName)
                            .font(.caption2)
                    }
                }
            }
        }
        
        Divider()
        
        // MapPOI showcase (used on map)
        VStack(spacing: 8) {
            Text("Map Markers (MapPOI)")
                .font(.subheadline)
                .fontWeight(.medium)
            
            HStack(spacing: 12) {
                VStack(spacing: 4) {
                    MapPOI(types: ["restaurant"], onTap: {})
                    Text("Restaurants")
                        .font(.caption2)
                }
                VStack(spacing: 4) {
                    MapPOI(types: ["cafe"], onTap: {})
                    Text("Cafés")
                        .font(.caption2)
                }
                VStack(spacing: 4) {
                    MapPOI(types: ["tourist_attraction"], onTap: {})
                    Text("Attractions")
                        .font(.caption2)
                }
                VStack(spacing: 4) {
                    MapPOI(types: ["store"], onTap: {})
                    Text("Shopping")
                        .font(.caption2)
                }
                VStack(spacing: 4) {
                    MapPOI(types: ["lodging"], onTap: {})
                    Text("Hotels")
                        .font(.caption2)
                }
            }
            HStack(spacing: 12) {
                VStack(spacing: 4) {
                    MapPOI(types: ["bus_station"], onTap: {})
                    Text("Transport")
                        .font(.caption2)
                }
                VStack(spacing: 4) {
                    MapPOI(types: ["hospital"], onTap: {})
                    Text("Health")
                        .font(.caption2)
                }
                VStack(spacing: 4) {
                    MapPOI(types: ["movie_theater"], onTap: {})
                    Text("Entertainment")
                        .font(.caption2)
                }
                VStack(spacing: 4) {
                    MapPOI(types: ["bank"], onTap: {})
                    Text("Services")
                        .font(.caption2)
                }
                VStack(spacing: 4) {
                    MapPOI(types: ["other"], onTap: {})
                    Text("Other")
                        .font(.caption2)
                }
            }
        }
    }
    .padding()
} 
