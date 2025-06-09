import SwiftUI
import GoogleMaps
import CoreLocation

struct GoogleMapView: UIViewRepresentable {
    @EnvironmentObject private var locationService: LocationService
    @State private var hasInitiallycentered = false
    
    // New properties for POI display
    let searchResults: [PlaceSearchResult]
    let onPOITapped: ((PlaceSearchResult) -> Void)?
    
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
        // Center on user location when it becomes available
        if let userLocation = locationService.currentLocation, !hasInitiallycentered {
            // Offset to position user location at 25% from top of screen
            // This shifts the map center down so user appears higher on screen
            let latitudeOffset = 0.006 // Increased to move location higher up
            
            let camera = GMSCameraPosition.camera(
                withLatitude: userLocation.coordinate.latitude - latitudeOffset,
                longitude: userLocation.coordinate.longitude,
                zoom: 15.0
            )
            uiView.camera = camera
            hasInitiallycentered = true
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
                rootView: MapPOI(place: place, onTap: {
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
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapView
        
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
        }
    )
    .environmentObject(LocationService.shared)
} 