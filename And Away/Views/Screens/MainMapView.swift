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
    @StateObject private var searchViewModel = SearchViewModel()
    @State private var selectedPlace: PlaceSearchResult?
    @State private var showPlaceDetails = false

    var body: some View {
        GoogleMapView(
            searchResults: searchViewModel.searchResults,
            onPOITapped: { place in
                selectedPlace = place
                showPlaceDetails = true
                sheetController.presentSheet(.details)
            }
        )
        .environmentObject(LocationService.shared)
        .ignoresSafeArea()
        .sheet(isPresented: $showSheet) {
            InitialSheetView()
                .environmentObject(sheetController)
                .environmentObject(searchViewModel)
                .environmentObject(LocationService.shared)
                .managedSheetDetents(controller: sheetController, level: .list)
        }
        .sheet(isPresented: $showPlaceDetails) {
            if let place = selectedPlace {
                PlaceDetailsView(
                    placeId: place.placeId,
                    onBackTapped: {
                        showPlaceDetails = false
                        sheetController.dismissSheet(.details)
                    }
                )
                .managedSheetDetents(controller: sheetController, level: .details)
            }
        }
    }
}

#Preview {
    MainMapView()
} 