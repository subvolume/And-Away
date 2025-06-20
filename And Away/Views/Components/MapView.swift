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
        
        // Set up delegate for location updates
        mapView.delegate = context.coordinator
        
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
        // Update map padding based on current sheet state
        updateMapPadding(for: uiView)
    }
    
    private func updateMapPadding(for mapView: GMSMapView) {
        // Calculate bottom padding based on sheet detent
        let bottomPadding = calculateSheetHeight()
        
        // Set padding - this moves the logical center of the map up
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: bottomPadding, right: 0)
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
        
        init(_ parent: GoogleMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
            // Auto-center on user location when it first becomes available
            if !hasInitialLocationSet, let userLocation = mapView.myLocation {
                hasInitialLocationSet = true
                let camera = GMSCameraPosition.camera(withTarget: userLocation.coordinate, zoom: 15.0)
                mapView.animate(to: camera)
            }
        }
    }
}

#Preview {
    GoogleMapView(sheetController: SheetController())
} 