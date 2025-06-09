// InitialSavedView.swift
// Created for And Away 

import SwiftUI
import CoreLocation

struct InitialSavedView: View {
    @StateObject private var bookmarkManager = BookmarkManager.shared
    @EnvironmentObject private var locationService: LocationService
    @EnvironmentObject private var sheetController: SheetController
    
    // Selected place state for details sheet
    @State private var selectedPlace: SavedPlace?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Saved places list with section header
                ScrollView {
                    LazyVStack(spacing: 0) {
                        SectionHeaderView(title: "Saved Places", showViewAllButton: false)
                        
                        ForEach(bookmarkManager.savedPlaces) { savedPlace in
                            ListItem.savedPlace(
                                from: savedPlace,
                                userLocation: locationService.currentLocation,
                                onOpenPlaceDetails: {
                                    selectedPlace = savedPlace
                                    sheetController.presentSheet(.details)
                                }
                            )
                        }
                    }
                    .padding(.top, Spacing.s)
                }
            }
            .refreshable {
                // Refresh saved places (if needed for cloud sync later)
                bookmarkManager.loadSavedPlaces()
            }
        }
        .sheet(isPresented: .constant(sheetController.activeSheets.contains(.details))) {
            if let place = selectedPlace {
                PlaceDetailsView(
                    placeId: place.placeId,
                    onBackTapped: {
                        selectedPlace = nil
                        sheetController.dismissSheet(.details)
                    }
                )
                .managedSheetDetents(controller: sheetController, level: .details)
            }
        }
    }
}

#Preview {
    InitialSavedView()
        .environmentObject(LocationService.shared)
        .environmentObject(SheetController())
} 