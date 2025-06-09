import SwiftUI

struct MapPOI: View {
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Image(systemName: "fork.knife")
                .font(.system(size: 8, weight: .medium))
                .foregroundColor(Color.white100)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .padding(2)
        .frame(width: 14, height: 14, alignment: .center)
        .background(Color.orange100)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .inset(by: -0.5)
            .stroke(Color.white100, lineWidth: 1)
        )
    }
}

#Preview {
    MapPOI()
} 