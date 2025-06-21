import SwiftUI

struct SheetHeader: View {
    let title: String
    let categoryName: String?
    let categoryIcon: Image?
    let categoryColor: Color?
    let onClose: () -> Void
    
    init(title: String, categoryName: String? = nil, categoryIcon: Image? = nil, categoryColor: Color? = nil, onClose: @escaping () -> Void) {
        self.title = title
        self.categoryName = categoryName
        self.categoryIcon = categoryIcon
        self.categoryColor = categoryColor
        self.onClose = onClose
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            // Top row with title and close button
            HStack(alignment: .top, spacing: Spacing.s) {
                Text(title)
                    .pageTitle()
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                PillButton(icon: "xmark") {
                    onClose()
                }
            }
            
            // Bottom row with type and status
            HStack(spacing: Spacing.m) {
                // Type indicator (if category info is provided)
                if let categoryName = categoryName, let categoryIcon = categoryIcon {
                    HStack(spacing: Spacing.xxs) {
                        categoryIcon
                            .font(.caption)
                            .foregroundColor(categoryColor ?? .tertiary)
                        
                        Text(categoryName)
                            .pageSubtitle()
                            .foregroundColor(.tertiary)
                    }
                }
                
                // Status indicator (Open) - keeping this as is for now
                HStack(spacing: Spacing.xxs) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                    
                    Text("Open")
                        .pageSubtitle()
                        .foregroundColor(.tertiary)
                }
                
                //Spacer()
            }
        }
        .padding(.horizontal, Spacing.m)
        .padding(.top, Spacing.m)
       // .padding(.bottom, Spacing.s)
    }
}

// Preview
#Preview {
    VStack(alignment: .leading, spacing: Spacing.xl) {
        // Normal title
        SheetHeader(title: "Point of Interest", onClose: { })
            .background(Color(.systemBackground))
        
        // Long title that wraps to 2 lines
        SheetHeader(title: "The Grand Central Market & Food Hall Experience", onClose: { })
            .background(Color(.systemBackground))
    }
    .padding()
} 
