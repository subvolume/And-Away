import SwiftUI

struct SheetB: View {
    @State private var selectedDetent: PresentationDetent = .medium
    
    var body: some View {
        Text("Sheet B")
            .presentationDetents([.height(100), .medium, .large], selection: $selectedDetent)
            .presentationDragIndicator(.visible)
            .interactiveDismissDisabled(true)
            .presentationBackgroundInteraction(.enabled)
            .presentationBackground(.black.opacity(0.3))
    }
}

#Preview {
    SheetB()
} 