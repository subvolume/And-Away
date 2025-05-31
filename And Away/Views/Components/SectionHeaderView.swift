import SwiftUI

struct SectionHeaderView: View {
    let title: String
    let showViewAllButton: Bool
    let onViewAllTapped: (() -> Void)?
    
    init(title: String, showViewAllButton: Bool = true, onViewAllTapped: (() -> Void)? = nil) {
        self.title = title
        self.showViewAllButton = showViewAllButton
        self.onViewAllTapped = onViewAllTapped
    }
    
    var body: some View {
        HStack {
            Text(title)
                .listTitle()
                .foregroundColor(.primary)
            
            Spacer()
            
            if showViewAllButton {
                Button("View all") {
                    onViewAllTapped?()
                }
                .foregroundColor(Color.tertiary)
                .font(FontStyle.listSubtitle)
            }
        }
        .padding(.horizontal, Spacing.m)
        .padding(.vertical, Spacing.xs)
    }
}

#Preview {
    VStack {
        SectionHeaderView(title: "Saved places")
        ListItem(artwork: .circleIcon(color: .green100, icon: Image(systemName: "star.fill")), title: "Favorite", subtitle: "Circle Icon")
        ListItem(artwork: .circleIcon(color: .green100, icon: Image(systemName: "star.fill")), title: "Favorite", subtitle: "Circle Icon")
        SectionHeaderView(title: "This Month")
        SectionHeaderView(title: "Today")
        SectionHeaderView(title: "This Week")
        SectionHeaderView(title: "Without Button", showViewAllButton: false)
    }
} 
