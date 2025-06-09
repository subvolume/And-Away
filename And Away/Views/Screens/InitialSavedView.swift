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
                if bookmarkManager.savedPlaces.isEmpty {
                    // Empty state
                    VStack(spacing: Spacing.l) {
                        Spacer()
                        
                        Image(systemName: "bookmark")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        
                        Text("No Saved Places")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Start exploring and bookmark places you want to remember")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Spacing.xl)
                        
                        Spacer()
                    }
                } else {
                    // Saved places list
                    ScrollView {
                        LazyVStack(spacing: 0) {
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
            }
            .navigationTitle("Saved Places")
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