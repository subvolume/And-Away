import SwiftUI

struct PlaceDetailsView: View {
    let onBackTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // Back button
            HStack {
                Button(action: onBackTapped) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .font(.body)
                            .fontWeight(.medium)
                        Text("Back")
                            .font(.body)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.blue)
                }
                Spacer()
            }
            .padding(.horizontal, Spacing.m)
            .padding(.top, Spacing.s)
            
            Spacer()
            
            // Main content
            Text("Place details")
                .pageTitle()
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

#Preview {
    PlaceDetailsView(onBackTapped: {
        print("Back tapped")
    })
} 