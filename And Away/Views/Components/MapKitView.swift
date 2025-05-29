import SwiftUI
import MapKit

struct MapKitView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Updates will be added here later if needed
    }
}

#Preview {
    MapKitView()
} 