import SwiftUI

struct PlaceDetailsActions: View {
    @State private var isBookmarked = false
    @State private var isTodaySelected = false
    
    var body: some View {
        HStack {
            PillButton(icon: "bookmark.fill", isSelected: isBookmarked) {
                isBookmarked.toggle()
            }
            
            PillButton(text: isTodaySelected ? "Today!" : "Today?", icon: isTodaySelected ? "checkmark" : "plus", isSelected: isTodaySelected) {
                isTodaySelected.toggle()
            }
            
            PillButton(icon: "message.fill") {
                // Chat action
            }
            
            PillButton(icon: "ellipsis") {
                // Menu action
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    PlaceDetailsActions()
} 
