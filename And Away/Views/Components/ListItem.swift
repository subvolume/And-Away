import SwiftUI

struct ListItem: View {
    let iconWidth: CGFloat = 32
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: Spacing.m) {
                Rectangle()
                    .frame(width: iconWidth, height: iconWidth)
                    .foregroundColor(.black)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Text1")
                        .listTitle()
                    HStack(spacing: 4) {
                        Text("Text2")
                            .listSubtitle()
                        Text("•")
                            .listSubtitle()
                        Text("Text3")
                            .listSubtitle()
                    }
                    .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.horizontal, Spacing.m)
            Divider()
                .padding(.leading, Spacing.m + iconWidth + Spacing.m)
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        ListItem()
        ListItem()
        ListItem()
        ListItem()
    }
} 
