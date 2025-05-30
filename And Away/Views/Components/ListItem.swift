import SwiftUI

struct ListItem: View {
    let iconWidth: CGFloat = 32
    let color: Color?
    let artwork: ArtworkType?
    let title: String
    let subtitle: String
    let thirdText: String?
    
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
    
    init(color: Color = .primary, title: String = "Text1", subtitle: String = "Text2", thirdText: String? = "Text3") {
        self.color = color
        self.artwork = nil
        self.title = title
        self.subtitle = subtitle
        self.thirdText = thirdText
    }
    
    init(artwork: ArtworkType, title: String, subtitle: String, thirdText: String? = nil) {
        self.color = nil
        self.artwork = artwork
        self.title = title
        self.subtitle = subtitle
        self.thirdText = thirdText
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
    }
}

#Preview {
    VStack(spacing: 0) {
        ListItem()
        ListItem(color: .azure100, title: "Azure", subtitle: "#128DFF", thirdText: nil)
        ListItem(artwork: .largeIcon(color: .red100, icon: Image(systemName: "house.fill")), title: "Home", subtitle: "Large Icon")
        ListItem(artwork: .circleIcon(color: .green100, icon: Image(systemName: "star.fill")), title: "Favorite", subtitle: "Circle Icon")
        ListItem(artwork: .icon(Image(systemName: "folder")), title: "Files", subtitle: "Simple Icon")
    }
} 
