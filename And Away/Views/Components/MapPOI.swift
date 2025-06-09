import SwiftUI

struct MapPOI: View {
    let types: [String]
    let onTap: (() -> Void)?
    
    var body: some View {
        let category = PlaceCategory.categorize(from: types)
        
        HStack(alignment: .center, spacing: 0) {
            PlaceVisuals.icon(for: category)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color.white100)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .padding(3)
        .frame(width: 22, height: 22, alignment: .center)
        .background(PlaceVisuals.color(for: category))
        .cornerRadius(11)
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
        .overlay(
          RoundedRectangle(cornerRadius: 11)
            .inset(by: -1)
            .stroke(Color.white100, lineWidth: 2)
        )
        .onTapGesture {
            onTap?()
        }
    }
}

#Preview {
    MapPOI(
        types: ["restaurant"],
        onTap: {}
    )
} 