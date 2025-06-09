import SwiftUI
import GoogleMaps
import CoreLocation

struct GoogleMapView: UIViewRepresentable {
    @EnvironmentObject private var locationService: LocationService
    
    // New properties for POI display
    let searchResults: [PlaceSearchResult]
    let onPOITapped: ((PlaceSearchResult) -> Void)?
    let selectedPlace: PlaceSearchResult?
    
    func makeUIView(context: Context) -> GMSMapView {
        // Create Google Map with similar settings to the original MapKit version
        let mapView = GMSMapView()
        
        // Enable user location (equivalent to showsUserLocation in MapKit)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        // Set map type to normal (equivalent to standard in MapKit)
        mapView.mapType = .normal
        
        // Enable zoom controls
        mapView.settings.zoomGestures = true
        mapView.settings.scrollGestures = true
        mapView.settings.rotateGestures = true
        mapView.settings.tiltGestures = true
        
        // Remove POI dots with a simpler approach
        do {
            let style = """
            [
              {
                "featureType": "poi",
                "elementType": "labels",
                "stylers": [
                  {
                    "visibility": "off"
                  }
                ]
              }
            ]
            """
            mapView.mapStyle = try GMSMapStyle(jsonString: style)
        } catch {
            print("Failed to load map style: \(error)")
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
        // Center on user location when it becomes available (but only if no place is selected)
        if let userLocation = locationService.currentLocation, !context.coordinator.hasInitiallycentered, selectedPlace == nil {
            // Offset to position user location at 25% from top of screen
            // This shifts the map center down so user appears higher on screen
            let latitudeOffset = 0.006 // Increased to move location higher up
            
            let camera = GMSCameraPosition.camera(
                withLatitude: userLocation.coordinate.latitude - latitudeOffset,
                longitude: userLocation.coordinate.longitude,
                zoom: 15.0
            )
            uiView.camera = camera
            context.coordinator.hasInitiallycentered = true
        }
        
        // Clear existing POI markers
        uiView.clear()
        
        // Add POI markers for search results
        for place in searchResults {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(
                latitude: place.geometry.location.lat,
                longitude: place.geometry.location.lng
            )
            marker.title = place.name
            marker.snippet = place.displayAddress
            
            // Create custom marker view using our MapPOI component
            let hostingController = UIHostingController(
                rootView: MapPOI(types: place.types, onTap: {
                    onPOITapped?(place)
                })
            )
            hostingController.view.backgroundColor = UIColor.clear
            hostingController.view.clipsToBounds = false
            // POI is 22x22, but shadow (radius 2, y offset 2) and stroke (inset -1, width 2) extend beyond
            // Need extra space: stroke extends ~3pts, shadow extends ~4pts vertically, ~2pts horizontally
            hostingController.view.frame = CGRect(x: 0, y: 0, width: 30, height: 32)
            
            // Ensure proper layout and prevent any parent clipping
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            hostingController.view.layer.masksToBounds = false
            hostingController.view.superview?.clipsToBounds = false
            
            marker.iconView = hostingController.view
            marker.map = uiView
            
            // Store place data for tap handling
            marker.userData = place
        }
        
        // Set up marker tap handler
        uiView.delegate = context.coordinator
        
        // Center on selected place if available
        if let selectedPlace = selectedPlace {
            let selectedLocation = CLLocationCoordinate2D(
                latitude: selectedPlace.geometry.location.lat,
                longitude: selectedPlace.geometry.location.lng
            )
            
            // Animate to center on the selected place
            // Offset slightly up to account for the details sheet
            let latitudeOffset = 0.003 // Move the place higher on screen when sheet is open
            let camera = GMSCameraPosition.camera(
                withLatitude: selectedLocation.latitude - latitudeOffset,
                longitude: selectedLocation.longitude,
                zoom: 16.0 // Slightly closer zoom when focusing on a place
            )
            
            uiView.animate(to: camera)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapView
        var hasInitiallycentered = false
        
        init(_ parent: GoogleMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            if let place = marker.userData as? PlaceSearchResult {
                parent.onPOITapped?(place)
            }
            return true
        }
    }
}

#Preview {
    GoogleMapView(
        searchResults: [],
        onPOITapped: { place in
            print("Tapped POI: \(place.name)")
        },
        selectedPlace: nil
    )
    .environmentObject(LocationService.shared)
} 