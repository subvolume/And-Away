//
//  ArtworkExampleView.swift
//  And Away
//
//  Created by Oliver Lukman on 29/05/2025.
//

import SwiftUI

struct ArtworkExampleView: View {
    
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
        ScrollView {
            VStack(spacing: 0) {
                // Large image examples
                ListItem(
                    artwork: .large(loadImage("cat01")),
                    title: "White Cat Portrait",
                    subtitle: "Large Image • 100x100"
                )
                
                ListItem(
                    artwork: .large(loadImage("cat02")),
                    title: "Sleepy Cat", 
                    subtitle: "Large Image • 100x100"
                )
                
                ListItem(
                    artwork: .large(loadImage("cat03")),
                    title: "Sunny Window Cat", 
                    subtitle: "Large Image • 100x100"
                )
                
                // Thumbnail examples
                ListItem(
                    artwork: .thumbnail(loadImage("cat04")),
                    title: "Cat on Stairs",
                    subtitle: "Thumbnail • 80x80"
                )
                
                ListItem(
                    artwork: .thumbnail(loadImage("cat05")),
                    title: "Cozy Cat",
                    subtitle: "Thumbnail • 80x80"
                )
                
                ListItem(
                    artwork: .thumbnail(loadImage("cat06")),
                    title: "Evening Cat",
                    subtitle: "Thumbnail • 80x80"
                )
                
                ListItem(
                    artwork: .thumbnail(loadImage("cat07")),
                    title: "Curious Cat",
                    subtitle: "Thumbnail • 80x80"
                )
                
                // Large icon examples
                ListItem(
                    artwork: .largeIcon(backgroundColor: .red100, icon: Image(systemName: "house.fill")),
                    title: "Home Base",
                    subtitle: "Large Icon • 80x80 frame"
                )
                
                ListItem(
                    artwork: .largeIcon(backgroundColor: .green100, icon: Image(systemName: "leaf.fill")),
                    title: "Nature Spot",
                    subtitle: "Large Icon • 80x80 frame"
                )
                
                // Circle icon examples
                ListItem(
                    artwork: .circleIcon(backgroundColor: .azure100, icon: Image(systemName: "star.fill")),
                    title: "Favorite Place",
                    subtitle: "Circle Icon • 32x32"
                )
                
                ListItem(
                    artwork: .circleIcon(backgroundColor: .purple100, icon: Image(systemName: "heart.fill")),
                    title: "Loved Location",
                    subtitle: "Circle Icon • 32x32"
                )
                
                // Simple icon examples
                ListItem(
                    artwork: .icon(Image(systemName: "folder.fill")),
                    title: "File Category",
                    subtitle: "Simple Icon • 32x32 frame"
                )
                
                ListItem(
                    artwork: .icon(Image(systemName: "tag.fill")),
                    title: "Tagged Item",
                    subtitle: "Simple Icon • 32x32 frame"
                )
            }
        }
        .navigationTitle("Artwork Examples")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Preview
struct ArtworkExampleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArtworkExampleView()
        }
    }
} 