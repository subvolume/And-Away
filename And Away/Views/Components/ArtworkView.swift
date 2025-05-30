import SwiftUI

// MARK: - Artwork Types
enum ArtworkType {
    case large(Image)
    case thumbnail(Image)
    case largeIcon(backgroundColor: Color, icon: Image)
    case circleIcon(backgroundColor: Color, icon: Image)
    case icon(Image)
}

// MARK: - Artwork View
struct ArtworkView: View {
    let artwork: ArtworkType
    
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
            
        case .largeIcon(let backgroundColor, let icon):
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(backgroundColor)
                    .frame(width: 80, height: 80)
                
                icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
            }
            
        case .circleIcon(let backgroundColor, let icon):
            ZStack {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: 32, height: 32)
                
                icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)
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
        ArtworkView(artwork: .largeIcon(backgroundColor: .red100, icon: Image(systemName: "house.fill")))
        
        // Circle icon - star with background
        ArtworkView(artwork: .circleIcon(backgroundColor: .azure100, icon: Image(systemName: "star.fill")))
        
        // Simple icon - folder
        ArtworkView(artwork: .icon(Image(systemName: "folder.fill")))
    }
    .padding()
} 