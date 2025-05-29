//
//  ContentView.swift
//  And Away
//
//  Created by Oliver Lukman on 29/05/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var showSheet = true
    var body: some View {
        MapKitView()
            .ignoresSafeArea()
            .sheet(isPresented: $showSheet) {
                CustomSheetView(showSearchBar: true)
                .presentationDetents([.medium, .large, .height(100)])
                .presentationBackgroundInteraction(.enabled)
            }
    }
}

#Preview {
    ContentView()
}
