import SwiftUI

/*
 Hidden Frame Technique:
 
 This carousel has hidden action areas on both sides that can be revealed by scrolling.
 
 How it works:
 1. Add frames before and after the main content: [LeftFrame] [Images] [RightFrame]
 2. Use .offset(x: -frameWidth) to shift everything left, hiding the left frame
 3. Use .padding(.trailing, -2*frameWidth) to hide the right frame 
    (accounts for both the frame width and the offset amount)
 
 Result: Only the images show initially, but users can scroll to discover the hidden frames.
 */

struct ImageCarouselView: View {
    let imageURLs: [URL]
    
    // Split images into top and bottom rows (up to 8 total)
    private var topImages: [URL] {
        Array(imageURLs.prefix(4))
    }
    
    private var bottomImages: [URL] {
        Array(imageURLs.dropFirst(4).prefix(4))
    }
    
    // Component for loading images from URLs with fade animation
    func asyncImageView(url: URL) -> some View {
        AsyncImageWithFade(url: url)
    }
    
    // Reusable carousel component
    func carouselRow(images: [URL]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.xxs) {
                // Left frame
                Rectangle()
                    .fill(Color.backgroundTertiary)
                    .frame(width: 100, height: 130)
                
                ForEach(images, id: \.self) { imageURL in
                    asyncImageView(url: imageURL)
                }
                
                // Right frame
                Rectangle()
                    .fill(Color.backgroundTertiary)
                    .frame(width: 100, height: 130)
            }
            .offset(x: -(100 + Spacing.xxs))
            .padding(.trailing, -2 * (100 + Spacing.xxs))
        }
    }
    
    var body: some View {
        VStack(spacing: Spacing.xxs) {
            carouselRow(images: topImages)
            carouselRow(images: bottomImages)
        }
        .frame(height: 260)
        .cornerRadius(20)
        .padding(.horizontal, Spacing.m)
    }
}

struct AsyncImageWithFade: View {
    let url: URL
    @State private var isLoaded = false
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 130)
                    .opacity(isLoaded ? 1 : 0)
                    .scaleEffect(isLoaded ? 1 : 0.98)
                    .onAppear {
                        withAnimation(.easeOut(duration: 0.4)) {
                            isLoaded = true
                        }
                    }
            case .failure(_):
                // Show nothing on failure - no space taken
                EmptyView()
            case .empty:
                // Show nothing while loading - no space taken
                EmptyView()
            @unknown default:
                EmptyView()
            }
        }
    }
}

#Preview {
    ImageCarouselView(imageURLs: [
        URL(string: "https://picsum.photos/300/300?random=1")!,
        URL(string: "https://picsum.photos/300/300?random=2")!,
        URL(string: "https://picsum.photos/300/300?random=3")!,
        URL(string: "https://picsum.photos/300/300?random=4")!
    ])
} 