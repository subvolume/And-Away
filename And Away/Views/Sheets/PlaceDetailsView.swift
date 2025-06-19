import SwiftUI

struct PlaceDetailsView: View {
    let placeId: String
    let onBackTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            SheetHeader(title: "Place Details", onClose: onBackTapped)
            
            ScrollView {
                VStack(spacing: 16) {
                    Text("Place ID: \(placeId)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding()
                    
                    Text("Place details will appear here")
                        .foregroundColor(.secondary)
                        .padding()
                    
                    Text("Data models will be set up in the next step")
                        .font(.caption)
                        .foregroundColor(.tertiary)
                }
                .padding(.top, 40)
            }
        }
    }
}

#Preview {
    PlaceDetailsView(placeId: "sample-place-id", onBackTapped: {})
} 
