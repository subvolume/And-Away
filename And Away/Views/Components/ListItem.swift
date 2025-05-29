import SwiftUI

struct ListItem: View {
    let iconWidth: CGFloat = 40
    let iconTextSpacing: CGFloat = 12
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: iconTextSpacing) {
                Rectangle()
                    .frame(width: iconWidth, height: iconWidth)
                    .foregroundColor(.black)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Text1")
                        .font(.headline)
                    HStack(spacing: 4) {
                        Text("Text2")
                        Text("•")
                        Text("Text3")
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.horizontal, Spacing.m)
            Divider()
                .padding(.leading, Spacing.m + iconWidth + iconTextSpacing)
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
