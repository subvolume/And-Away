//
//  MainMapView.swift
//  And Away
//
//  Created by Oliver Lukman on 29/05/2025.
//

import SwiftUI

struct MainMapView: View {
    @State private var showSheet = true
    @State private var selectedDetent: PresentationDetent = .medium

    var body: some View {
        MapKitView()
            .ignoresSafeArea()
            .sheet(isPresented: $showSheet) {
                InitialSheetView()
                    .presentationDetents([.height(100), .medium, .fraction(0.99)], selection: $selectedDetent)
                    .presentationBackgroundInteraction(.enabled)
                    .interactiveDismissDisabled()
            }
    }
}

#Preview {
    MainMapView()
} 