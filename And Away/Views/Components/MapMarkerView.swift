import SwiftUI

struct MapMarkerView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.red)
                .frame(width: 22, height: 22)
            
            Image(systemName: "mappin")
                .foregroundColor(.white)
                .font(.system(size: 12, weight: .medium))
        }
    }
}

#Preview {
    MapMarkerView()
} 