import SwiftUI

struct SheetA: View {
    @State private var showSheetB = false
    @State private var selectedDetent: PresentationDetent = .medium
    
    var body: some View {
        VStack {
            Text("Sheet A")
            
            Button("Open Sheet B") {
                showSheetB = true
            }
            .padding()
        }
        .presentationDetents([.height(100), .medium, .large], selection: $selectedDetent)
        .presentationDragIndicator(.visible)
        .interactiveDismissDisabled(true)
        .presentationBackgroundInteraction(.enabled)
        .sheet(isPresented: $showSheetB) {
            SheetB()
        }
    }
}

#Preview {
    SheetA()
} 
