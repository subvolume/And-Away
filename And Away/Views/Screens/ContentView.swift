//
//  ContentView.swift
//  And Away
//
//  Created by Oliver Lukman on 29/05/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var showSheet = true
    @State private var selectedDetent: PresentationDetent = .medium

    var body: some View {
        MapKitView()
            .ignoresSafeArea()
            .sheet(isPresented: $showSheet) {
                CustomSheetView(showSearchBar: true)
                    .presentationDetents([.height(100), .medium, .large], selection: $selectedDetent)
                    .presentationBackgroundInteraction(.enabled)
                    .interactiveDismissDisabled()
            }
    }
}

#Preview {
    ContentView()
}
