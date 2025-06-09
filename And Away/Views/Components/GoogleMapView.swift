import SwiftUI
import GoogleMaps
import CoreLocation

struct GoogleMapView: UIViewRepresentable {
    @EnvironmentObject private var locationService: LocationService
    @State private var hasInitiallycentered = false
    
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
            let latitudeOffset = 0.003 // Adjust this value to fine-tune positioning
            
            let camera = GMSCameraPosition.camera(
                withLatitude: userLocation.coordinate.latitude - latitudeOffset,
                longitude: userLocation.coordinate.longitude,
                zoom: 15.0
            )
            uiView.camera = camera
            hasInitiallycentered = true
        }
    }
}

#Preview {
    GoogleMapView()
} 