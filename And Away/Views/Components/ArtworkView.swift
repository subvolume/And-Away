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
    VStack(spacing: 20) {
        ArtworkView(artwork: .large(Image(systemName: "photo")))
        ArtworkView(artwork: .thumbnail(Image(systemName: "photo")))
        ArtworkView(artwork: .largeIcon(backgroundColor: .red100, icon: Image(systemName: "house")))
        ArtworkView(artwork: .circleIcon(backgroundColor: .azure100, icon: Image(systemName: "star")))
        ArtworkView(artwork: .icon(Image(systemName: "folder")))
    }
    .padding()
} 