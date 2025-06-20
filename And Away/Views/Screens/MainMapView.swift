//
//  MainMapView.swift
//  And Away
//
//  Created by Oliver Lukman on 29/05/2025.
//

import SwiftUI
import CoreLocation

struct MainMapView: View {
    @State private var showSheet = true
    @StateObject private var sheetController = SheetController()
    @State private var userLocation: CLLocationCoordinate2D?

    var body: some View {
        GoogleMapView(
            sheetController: sheetController,
            onLocationUpdate: { location in
                userLocation = location
            }
        )
        .ignoresSafeArea()
        .sheet(isPresented: $showSheet) {
            InitialSheetView(userLocation: userLocation)
                .environmentObject(sheetController)
                .managedSheetDetents(controller: sheetController, level: .list)
        }
    }
}

#Preview {
    MainMapView()
} 