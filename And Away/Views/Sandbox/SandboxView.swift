import SwiftUI
import MapKit

struct SandboxView: View {
    @State private var showSheetA = true
    
    var body: some View {
        Map()
            .ignoresSafeArea()
            .sheet(isPresented: $showSheetA) {
                SheetA()
            }
    }
}

// This lets you see the view in Xcode's preview
#Preview {
    SandboxView()
}
