import SwiftUI

// MARK: - Artwork Types
enum ArtworkType {
    case large(Image)
    case thumbnail(Image)
    case largeIcon(color: Color, icon: Image)
    case circleIcon(color: Color, icon: Image)
    case icon(Image)
}

// MARK: - Artwork View
struct ArtworkView: View {
    let artwork: ArtworkType
    
    // Helper function to get background color (15% opacity)
    private func backgroundColorFor(_ color: Color) -> Color {
        switch color {
        case .red100: return .red15
        case .orange100: return .orange15
        case .yellow100: return .yellow15
        case .green100: return .green15
        case .teal100: return .teal15
        case .aqua100: return .aqua15
        case .sky100: return .sky15
        case .azure100: return .azure15
        case .blue100: return .blue15
        case .purple100: return .purple15
        case .lilac100: return .lilac15
        case .lavender100: return .lavender15
        default: return color.opacity(0.15)
        }
    }
    
    var body: some View {
        switch artwork {
        case .large(let image):
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipped()
                .cornerRadius(12)
            
        case .thumbnail(let image):
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipped()
                .cornerRadius(10)
            
        case .largeIcon(let color, let icon):
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(backgroundColorFor(color))
                    .frame(width: 80, height: 80)
                
                icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .foregroundColor(color)
            }
            
        case .circleIcon(let color, let icon):
            ZStack {
                Circle()
                    .fill(backgroundColorFor(color))
                    .frame(width: 32, height: 32)
                
                icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(color)
            }
            
        case .icon(let icon):
            icon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .frame(width: 32, height: 32) // 32x32 frame
        }
    }
}

// MARK: - Preview
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
    
    return VStack(spacing: 20) {
        // Large image - cat photo
        ArtworkView(artwork: .large(loadImage("cat01")))
        
        // Thumbnail - cat photo
        ArtworkView(artwork: .thumbnail(loadImage("cat02")))
        
        // Large icon - house with background
        ArtworkView(artwork: .largeIcon(color: .red100, icon: Image(systemName: "house.fill")))
        
        // Circle icon - star with background
        ArtworkView(artwork: .circleIcon(color: .azure100, icon: Image(systemName: "star.fill")))
        
        // Circle icons in HStack
        HStack(spacing: 12) {
            ArtworkView(artwork: .circleIcon(color: .red100, icon: Image(systemName: "heart.fill")))
            ArtworkView(artwork: .circleIcon(color: .green100, icon: Image(systemName: "leaf.fill")))
            ArtworkView(artwork: .circleIcon(color: .blue100, icon: Image(systemName: "drop.fill")))
            ArtworkView(artwork: .circleIcon(color: .purple100, icon: Image(systemName: "star.fill")))
            ArtworkView(artwork: .circleIcon(color: .orange100, icon: Image(systemName: "flame.fill")))
        }
        
        // Simple icon - folder
        ArtworkView(artwork: .icon(Image(systemName: "folder.fill")))
    }
    .padding()
} 
