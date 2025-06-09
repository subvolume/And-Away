import SwiftUI

struct SheetHeader: View {
    let title: String
    let placeType: String?
    let openStatus: String?
    let isOpen: Bool?
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
                // Type indicator
                if let placeType = placeType {
                    HStack(spacing: Spacing.xxs) {
                        PlaceTypeHelpers.iconForPlaceType([placeType])
                            .font(.caption)
                            .foregroundColor(.tertiary)
                        
                        Text(placeType)
                            .pageSubtitle()
                            .foregroundColor(.tertiary)
                    }
                }
                
                // Status indicator
                if let openStatus = openStatus {
                    HStack(spacing: Spacing.xxs) {
                        Image(systemName: isOpen == true ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(isOpen == true ? .green : .red)
                        
                        Text(openStatus)
                            .pageSubtitle()
                            .foregroundColor(.tertiary)
                    }
                }
                
                //Spacer()
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
        SheetHeader(title: "Point of Interest", placeType: "Restaurant", openStatus: "Open", isOpen: true, onClose: { })
            .background(Color(.systemBackground))
        
        // Long title that wraps to 2 lines
        SheetHeader(title: "The Grand Central Market & Food Hall Experience", placeType: "Food Court", openStatus: "Closed", isOpen: false, onClose: { })
            .background(Color(.systemBackground))
    }
    //.padding()
}
