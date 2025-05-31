import SwiftUI

struct PlaceDetailsActions: View {
    @State private var isBookmarked = false
    
    var body: some View {
        HStack {
            PillButton(icon: "bookmark.fill", isSelected: isBookmarked) {
                isBookmarked.toggle()
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    PlaceDetailsActions()
} 