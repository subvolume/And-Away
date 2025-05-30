import SwiftUI

struct ImageCarouselView: View {
    let topImages = ["cat01", "cat02", "cat03", "cat04"]
    let bottomImages = ["cat05", "cat06", "cat07", "cat08"]
    
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
        VStack(spacing: Spacing.xxs) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.xxs) {
                    ForEach(topImages, id: \.self) { imageName in
                        loadImage(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.xxs) {
                    ForEach(bottomImages, id: \.self) { imageName in
                        loadImage(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
            }
        }
        .frame(height: 260)
        .cornerRadius(20)
        .padding(.horizontal, Spacing.m)
    }
}

#Preview {
    ImageCarouselView()
} 