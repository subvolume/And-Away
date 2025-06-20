import SwiftUI

struct ListItem: View {
    let iconWidth: CGFloat = 32
    let color: Color?
    let artwork: ArtworkType?
    let title: String
    let subtitle: String
    let thirdText: String?
    let onTap: (() -> Void)?
    
    // Computed property to get the actual artwork width
    private var actualArtworkWidth: CGFloat {
        guard let artwork = artwork else { return iconWidth }
        
        switch artwork {
        case .large(_):
            return 100
        case .thumbnail(_), .largeIcon(_, _):
            return 80
        case .circleIcon(_, _), .icon(_):
            return 32
        }
    }
    
    init(color: Color = .primary, title: String = "Text1", subtitle: String = "Text2", thirdText: String? = "Text3", onTap: (() -> Void)? = nil) {
        self.color = color
        self.artwork = nil
        self.title = title
        self.subtitle = subtitle
        self.thirdText = thirdText
        self.onTap = onTap
    }
    
    init(artwork: ArtworkType, title: String, subtitle: String, thirdText: String? = nil, onTap: (() -> Void)? = nil) {
        self.color = nil
        self.artwork = artwork
        self.title = title
        self.subtitle = subtitle
        self.thirdText = thirdText
        self.onTap = onTap
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: Spacing.m) {
                if let artwork = artwork {
                    ArtworkView(artwork: artwork)
                } else if let color = color {
                    Rectangle()
                        .frame(width: iconWidth, height: iconWidth)
                        .foregroundColor(color)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.tertiary.opacity(0.3), lineWidth: 1)
                        )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .listTitle()
                    HStack(spacing: 4) {
                        Text(subtitle)
                            .listSubtitle()
                        if let thirdText = thirdText {
                            Text("•")
                                .listSubtitle()
                            Text(thirdText)
                                .listSubtitle()
                        }
                    }
                    .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.horizontal, Spacing.m)
            Divider()
                .padding(.leading, Spacing.m + actualArtworkWidth + Spacing.m)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap?()
        }
    }
    
    // MARK: - Templates
    
    /// Saved place template with thumbnail image - always opens place details
    static func savedPlace(title: String, type: String, distance: String, location: String, image: Image, onOpenPlaceDetails: @escaping () -> Void) -> ListItem {
        return ListItem(
            artwork: .thumbnail(image),
            title: title,
            subtitle: "\(type) • \(distance) • \(location)",
            onTap: onOpenPlaceDetails
        )
    }
    
    /// Search result template with circular icon - always opens place details
    static func searchResult(title: String, distance: String, location: String, icon: Image, iconColor: Color = .red100, onOpenPlaceDetails: @escaping () -> Void) -> ListItem {
        return ListItem(
            artwork: .circleIcon(color: iconColor, icon: icon),
            title: title,
            subtitle: "\(distance) • \(location)",
            onTap: onOpenPlaceDetails
        )
    }
}

#Preview {
    // Helper function to load images in preview
    func loadImage(_ name: String) -> Image {
        if let path = Bundle.main.path(forResource: name, ofType: "png"),
           let uiImage = UIImage(contentsOfFile: path) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "photo.fill") // Fallback
        }
    }
    
    return VStack(spacing: 0) {
        ListItem()
        ListItem.savedPlace(
            title: "Name of the place",
            type: "Park",
            distance: "Sample distance",
            location: "Barcelona",
            image: loadImage("cat01"), // Now using the helper function
            onOpenPlaceDetails: {}
        )
        ListItem.searchResult(
            title: "Name of the place",
            distance: "Sample distance",
            location: "Barcelona",
            icon: Image(systemName: "building.columns"),
            onOpenPlaceDetails: {}
        )
        ListItem(color: .azure100, title: "Azure", subtitle: "#128DFF", thirdText: nil, onTap: nil)
    }
} 
