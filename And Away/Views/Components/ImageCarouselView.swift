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
    let images = ["cat01", "cat02", "cat03", "cat04", "cat05", "cat06", "cat07", "cat08"]
    
    // Helper function to load images using UIImage with proper aspect ratio
    func loadImage(_ name: String) -> Image {
        if let path = Bundle.main.path(forResource: name, ofType: "png"),
           let uiImage = UIImage(contentsOfFile: path) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "photo.fill") // Fallback
        }
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.s) {
                ForEach(images, id: \.self) { imageName in
                    loadImage(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 150)
                        .clipped()
                        .cornerRadius(20)
                }
            }
            .padding(.horizontal, Spacing.m)
        }
        .frame(height: 150)
    }
}

#Preview {
    ImageCarouselView()
} 
