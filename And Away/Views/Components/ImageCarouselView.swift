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
    
    // Component for loading images from URLs (matching original design)
    func asyncImageView(url: URL) -> some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .overlay(
                    ProgressView()
                        .scaleEffect(0.8)
                )
        }
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

#Preview {
    ImageCarouselView(imageURLs: [
        URL(string: "https://picsum.photos/300/300?random=1")!,
        URL(string: "https://picsum.photos/300/300?random=2")!,
        URL(string: "https://picsum.photos/300/300?random=3")!,
        URL(string: "https://picsum.photos/300/300?random=4")!
    ])
} 