import SwiftUI

struct SheetHeader: View {
    let title: String
    let onClose: () -> Void
    
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
                // Type indicator (Restaurant)
                HStack(spacing: Spacing.xxs) {
                    Image(systemName: "fork.knife")
                        .font(.caption)
                        .foregroundColor(.tertiary)
                    
                    Text("Restaurant")
                        .pageSubtitle()
                        .foregroundColor(.tertiary)
                }
                
                // Status indicator (Open)
                HStack(spacing: Spacing.xxs) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                    
                    Text("Open")
                        .pageSubtitle()
                        .foregroundColor(.tertiary)
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, Spacing.m)
        .padding(.top, Spacing.m)
        .padding(.bottom, Spacing.s)
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
