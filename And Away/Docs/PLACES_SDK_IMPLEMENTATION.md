# Google Places Swift SDK Implementation Plan

## Project: And Away iOS App

### Current State
- ✅ SwiftUI app with sophisticated UI architecture
- ✅ Complete search flow UI (empty state, results, details)
- ✅ MapKit integration with user location
- ✅ Sheet management system
- ❌ Placeholder content in search/details views

---

## Implementation Steps

### Phase 1: SDK Setup
1. **Add Google Places Swift SDK**
   - Add package dependency: `https://github.com/googlemaps/ios-places-sdk`
   - Select `GooglePlacesSwift` product (version 10.0+)

2. **Configure API Key**
   - Get Google Places API key from Google Cloud Console
   - Add to `And_AwayApp.swift`:
   ```swift
   import GooglePlacesSwift
   
   init() {
       PlacesClient.provideAPIKey("YOUR_API_KEY")
   }
   ```

### Phase 2: Search Integration
3. **Create Places Service Protocol**
   - Centralize all SDK calls in one thin wrapper
   - Easy to stub for testing, update if Google changes API
   ```swift
   protocol PlacesService {
       func searchPlaces(query: String) async -> Result<[Place], PlacesError>
       func fetchPlace(placeID: String) async -> Result<Place, PlacesError>
   }
   
   final class GooglePlacesService: PlacesService {
       // All SDK calls isolated here
   }
   ```

4. **Wire Up Search Results**
   - Replace placeholder in `SearchResultsView.swift`
   - Add direct SDK call with required request object:
   ```swift
   let searchRequest = SearchByTextRequest(
       textQuery: query,
       placeProperties: [.name, .placeID, .formattedAddress]
   )
   let places = try await PlacesClient.shared.searchByText(with: searchRequest)
   ```
   - Display results using existing `ListItem` components

5. **Connect Place Selection**
   - Pass only `placeID` strings between views (lightweight, Codable)
   - Fresh data fetch in details view ensures up-to-date information
   - Simplifies navigation state and persistence

### Phase 3: Place Details
6. **Implement Place Details View**
   - Replace placeholder in `PlaceDetailsView.swift`
   - Fetch place details with required request object:
   ```swift
   let detailsRequest = FetchPlaceRequest(
       placeID: placeID,
       placeProperties: [.name, .formattedAddress, .rating, .photos]
   )
   let place = try await PlacesClient.shared.fetchPlace(with: detailsRequest)
   ```
   - Display place info, photos, ratings directly from SDK types

### Phase 4: Map Integration
7. **Add Places to Map**
   - Update `MapKitView.swift` to show place markers
   - Sync markers with search results
   - Handle marker selection

### Phase 5: Polish
8. **Add Loading States & Error Handling**
   - Simple `do/catch` blocks for SDK calls
   - Loading indicators during searches
   - Basic error messaging

---

## Key Realizations
- **No custom data models needed** → Use SDK `Place` types directly
- **Thin service protocol only** → One file to isolate SDK calls for API updates/testing
- **No caching needed** → SDK handles caching internally
- **No complex error mapping** → SDK provides proper Swift errors

## What We're Actually Building
```swift
// SearchResultsView - simplified
@State private var places: [Place] = []

List(places) { place in
    ListItem.searchResult(place: place)
}
.task {
    let searchRequest = SearchByTextRequest(
        textQuery: searchText,
        placeProperties: [.name, .placeID, .formattedAddress]
    )
    
    switch await PlacesClient.shared.searchByText(with: searchRequest) {
    case .success(let results):
        places = results
    case .failure(let error):
        // Handle PlacesError
    }
}
```

---

## Notes
- Modern Swift SDK eliminates most complexity
- Existing UI architecture is perfect for direct SDK integration
- Focus on replacing placeholders, not building infrastructure 