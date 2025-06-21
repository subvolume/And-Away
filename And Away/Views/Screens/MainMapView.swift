//
//  MainMapView.swift
//  And Away
//
//  Created by Oliver Lukman on 29/05/2025.
//

import SwiftUI
import CoreLocation
import GoogleMaps

struct MainMapView: View {
    @StateObject private var sheetController = SheetController()
    @State private var userLocation: CLLocationCoordinate2D?
    @State private var mapVisibleRegion: GMSVisibleRegion?
    @State private var mapZoom: Float = 15.0

    var body: some View {
        ZStack {
            GoogleMapView(
                sheetController: sheetController,
                onLocationUpdate: { location in
                    userLocation = location
                },
                onMapStateUpdate: { visibleRegion, zoom in
                    mapVisibleRegion = visibleRegion
                    mapZoom = zoom
                }
            )
            .ignoresSafeArea()
        }
        .sheet(isPresented: .constant(true)) {
            InitialSheetView(
                userLocation: userLocation,
                mapVisibleRegion: mapVisibleRegion,
                mapZoom: mapZoom
            )
            .environmentObject(sheetController)
            .managedSheetDetents(controller: sheetController, level: .list)
            .interactiveDismissDisabled()
        }
    }
}

#Preview {
    MainMapView()
} 