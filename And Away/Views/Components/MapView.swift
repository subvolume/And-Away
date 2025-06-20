import SwiftUI
import GoogleMaps

struct GoogleMapView: UIViewRepresentable {
    @ObservedObject var sheetController: SheetController
    
    func makeUIView(context: Context) -> GMSMapView {
        // Create the map view with a more generic initial camera position
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 2.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        // Configure map settings following best practices
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.settings.zoomGestures = true
        mapView.settings.scrollGestures = true
        mapView.settings.rotateGestures = true
        mapView.settings.tiltGestures = true
        
        // Hide default POI markers for a clean map
        mapView.settings.consumesGesturesInView = false
        
        // Create a minimal map style that hides POI markers
        do {
            // JSON style to hide points of interest
            let styleJSON = """
            [
                {
                    "featureType": "poi",
                    "stylers": [
                        {
                            "visibility": "off"
                        }
                    ]
                },
                {
                    "featureType": "poi.business",
                    "stylers": [
                        {
                            "visibility": "off"
                        }
                    ]
                },
                {
                    "featureType": "transit.station",
                    "stylers": [
                        {
                            "visibility": "off"
                        }
                    ]
                }
            ]
            """
            
            let style = try GMSMapStyle(jsonString: styleJSON)
            mapView.mapStyle = style
        } catch {
            print("Failed to load map style: \(error)")
        }
        
        // Set up delegate for location updates
        mapView.delegate = context.coordinator
        
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
        // No longer updating map padding here - only done once during initial setup
    }
    
    // MARK: - Marker Management Methods
    
    /// Add a marker to the map at the specified coordinates
    func addMarker(at coordinate: CLLocationCoordinate2D, title: String? = nil, snippet: String? = nil, context: Context) -> GMSMarker {
        return context.coordinator.addMarker(at: coordinate, title: title, snippet: snippet)
    }
    
    /// Remove all markers from the map
    func clearAllMarkers(context: Context) {
        context.coordinator.clearAllMarkers()
    }
    
    /// Get all current markers
    func getAllMarkers(context: Context) -> [GMSMarker] {
        return context.coordinator.getAllMarkers()
    }
    
    private func calculateSheetHeight() -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        let safeAreaBottom = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets.bottom ?? 0
        
        // Get the active sheet's current detent
        let activeSheet = sheetController.activeSheets.first ?? .list
        let currentDetent = sheetController.sheetDetents[activeSheet.index]
        
        // Calculate approximate height based on detent type
        // Since PresentationDetent doesn't expose internal values easily,
        // we'll use reasonable estimates for the common detent types
        if currentDetent == .medium {
            // Medium is typically around 50% of screen height
            return (screenHeight * 0.5) + safeAreaBottom
        } else if currentDetent == .large {
            // Large is typically around 75% of screen height  
            return (screenHeight * 0.75) + safeAreaBottom
        } else {
            // For height-based detents and others, use a conservative estimate
            // This covers .height(100), .height(1), etc.
            return (screenHeight * 0.3) + safeAreaBottom
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapView
        private var hasInitialLocationSet = false
        private var markers: [GMSMarker] = [] // Store all markers for management
        private weak var mapView: GMSMapView? // Keep reference to map view
        
        init(_ parent: GoogleMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
            // Store reference to mapView for marker management
            self.mapView = mapView
            
            // Auto-center on user location when it first becomes available
            // AND set up sheet-aware padding - but only once
            if !hasInitialLocationSet, let userLocation = mapView.myLocation {
                hasInitialLocationSet = true
                
                // Set initial map padding based on current sheet state
                let bottomPadding = parent.calculateSheetHeight()
                mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: bottomPadding, right: 0)
                
                // Then center on user location with the padding applied
                let camera = GMSCameraPosition.camera(withTarget: userLocation.coordinate, zoom: 15.0)
                mapView.animate(to: camera)
            }
        }
        
        // MARK: - Marker Management Methods
        
        /// Add a marker to the map at the specified coordinates
        func addMarker(at coordinate: CLLocationCoordinate2D, title: String? = nil, snippet: String? = nil) -> GMSMarker {
            guard let mapView = self.mapView else {
                fatalError("MapView reference not available")
            }
            
            let marker = GMSMarker(position: coordinate)
            marker.title = title
            marker.snippet = snippet
            marker.map = mapView
            
            // Store marker for management
            markers.append(marker)
            
            return marker
        }
        
        /// Remove a specific marker from the map
        func removeMarker(_ marker: GMSMarker) {
            marker.map = nil
            markers.removeAll { $0 === marker }
        }
        
        /// Remove all markers from the map
        func clearAllMarkers() {
            markers.forEach { $0.map = nil }
            markers.removeAll()
        }
        
        /// Get all current markers
        func getAllMarkers() -> [GMSMarker] {
            return markers
        }
        
        /// Remove markers by title (useful for removing specific types of markers)
        func removeMarkers(withTitle title: String) {
            let markersToRemove = markers.filter { $0.title == title }
            markersToRemove.forEach { removeMarker($0) }
        }
    }
}

#Preview {
    GoogleMapView(sheetController: SheetController())
} 