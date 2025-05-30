import SwiftUI

struct ListItem: View {
    let iconWidth: CGFloat = 32
    let color: Color
    let title: String
    let subtitle: String
    let thirdText: String?
    
    init(color: Color = .primary, title: String = "Text1", subtitle: String = "Text2", thirdText: String? = "Text3") {
        self.color = color
        self.title = title
        self.subtitle = subtitle
        self.thirdText = thirdText
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: Spacing.m) {
                Rectangle()
                    .frame(width: iconWidth, height: iconWidth)
                    .foregroundColor(color)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.tertiary.opacity(0.3), lineWidth: 1)
                    )
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .listTitle()
                    HStack(spacing: 4) {
                        Text(subtitle)
                            .listSubtitle()
                        if let thirdText = thirdText {
                            Text("•")
                                .listSubtitle()
                            Text(thirdText)
                                .listSubtitle()
                        }
                    }
                    .foregroundColor(.secondary)
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
        ListItem(color: .azure100, title: "Azure", subtitle: "#128DFF", thirdText: nil)
        ListItem(color: .green100, title: "Green", subtitle: "Primary", thirdText: "Success")
        ListItem()
    }
} 
