//
//  MainMapView.swift
//  And Away
//
//  Created by Oliver Lukman on 29/05/2025.
//

import SwiftUI

struct MainMapView: View {
    @State private var showSheet = true
    @StateObject private var sheetController = SheetController()

    var body: some View {
        MapKitView()
            .ignoresSafeArea()
            .sheet(isPresented: $showSheet) {
                InitialSheetView()
                    .environmentObject(sheetController)
                    .managedSheetDetents(controller: sheetController, level: .list)
            }
    }
}

#Preview {
    MainMapView()
} 