import SwiftUI

struct PlaceDetailsView: View {
    let onBackTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Use existing SheetHeader component instead of custom back button
            SheetHeader(title: "Place Details", onClose: onBackTapped)
            
            ScrollView {
                VStack(spacing: 20) {
                    Spacer()
                    
                    // Main content
                    Text("Place details")
                        .pageTitle()
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    PlaceDetailsView(onBackTapped: {
        print("Back tapped")
    })
} 