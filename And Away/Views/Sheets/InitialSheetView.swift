import SwiftUI

struct InitialSheetView: View {
    @State private var searchText = ""
    @State private var isSearchActive = false
    
    var body: some View {
        VStack {
            SearchBarView(text: $searchText, isEditing: $isSearchActive)
            
            ScrollView {
                if isSearchActive || !searchText.isEmpty {
                    SearchStateView(searchText: $searchText, onPlaceTapped: { place in
                        // Handle place selection here
                        print("Selected place: \(place.name)")
                    })
                } else {
                    DummyView()
                }
            }
        }
    }
}

#Preview {
    InitialSheetView()
} 