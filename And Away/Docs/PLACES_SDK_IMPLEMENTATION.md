# Google Places Swift SDK Implementation Plan

> **AI Collaboration Guide:**
> This document is our shared checklist. We will proceed through it one step at a time. The AI agent is responsible for updating the checkboxes as we complete and verify each task. Please do not move to the next item until we have confirmed the current one is working as expected.

## Project: And Away iOS App

### Current State
- [x] SwiftUI app with sophisticated UI architecture
- [x] Complete search flow UI (empty state, results, details)
- [x] MapKit integration with user location
- [x] Sheet management system
- [ ] Placeholder content in search/details views

---

## Implementation Steps

### Phase 1: SDK Setup
- [x] **Add Google Places Swift SDK**
   - Add package dependency: `https://github.com/googlemaps/ios-places-sdk`
   - Select `GooglePlacesSwift` product (version 10.0+)
   - [x] **Verification:** Project builds successfully. `import GooglePlacesSwift` does not cause an error.

- [x] **Configure API Key**
   - Get Google Places API key from Google Cloud Console
   - Add to `And_AwayApp.swift`:
   ```swift
   import GooglePlacesSwift
   
   init() {
       PlacesClient.provideAPIKey("YOUR_API_KEY")
   }
   ```
   - [x] **Verification:** App launches without crashing. No API key-related errors appear in the console.

### Phase 2: Search Integration
- [x] **Create Places Service Protocol**
   - Centralize all SDK calls in one thin wrapper
   - Easy to stub for testing, update if Google changes API
   ```swift
   protocol PlacesService {
       func searchPlaces(query: String) async -> Result<[Place], PlacesError>
       func fetchPlace(placeID: String) async -> Result<Place, PlacesError>
   }
   ```
   - [x] **Verification:** ✅ **COMPLETED** - Places service builds successfully with correct GooglePlacesSwift SDK API usage including proper PlaceProperty enum values (.displayName, .coordinate, .numberOfUserRatings, .websiteURL).

- [x] **Wire Up Search Results**
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
   - [x] **Verification:** ✅ **COMPLETED** - SearchResultsView now uses real Google Places data via the PlacesService, displays results with ListItem.searchResult template, includes loading states and error handling.

- [x] **Connect Place Selection**
   - Pass only `placeID` strings between views (lightweight, Codable)
   - Fresh data fetch in details view ensures up-to-date information
   - Simplifies navigation state and persistence
   - [x] **Verification:** ✅ **COMPLETED** - Navigation flow working correctly: search results pass place IDs to details view via existing sheet management system.

### Phase 3: Place Details
- [x] **Implement Place Details View**
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
   - [x] **Verification:** ✅ **COMPLETED** - PlaceDetailsView now fetches and displays real place data including name, address, rating, phone, website, and coordinates with proper loading/error states. Swift SDK compatibility issues resolved (numberOfUserRatings and location are non-optional properties).

### Phase 4: Map Integration
- [x] **Create Map Marker Component**
    - Create new view where the marker is a 22x22 circular background containing a sf symbol icon.
    - [x] **Verification:** ✅ **COMPLETED** - MapMarkerView created with 22x22 red circular background and white mappin SF Symbol icon.
- [ ] **Add Places to Map**
   - Update `MapKitView.swift` to show place markers
   - Sync markers with search results
   - Handle marker selection
   - [ ] **Verification:** Place markers appear on the map corresponding to the search results.

### Phase 5: Polish
- [ ] **Add Loading States & Error Handling**
   - Simple `do/catch` blocks for SDK calls
   - Loading indicators during searches
   - Basic error messaging
   - [ ] **Verification:** A loading indicator is visible during searches. An error message appears if a search fails (e.g., with no network).

---

## Key Realizations
- **No custom data models needed** → Use SDK `Place` types directly
- **Thin service protocol only** → One file to isolate SDK calls for API updates/testing
- **No caching needed** → SDK handles caching internally
- **No complex error mapping** → SDK provides proper Swift errors

---

## Notes
- Modern Swift SDK eliminates most complexity
- Existing UI architecture is perfect for direct SDK integration
- Focus on replacing placeholders, not building infrastructure

## Documentation References
- **Official GooglePlacesSwift SDK Reference:** https://developers.google.com/maps/documentation/places/ios-sdk/reference/swift/Enums/PlaceProperty
- **PlaceProperty Enum Values:** https://developers.google.com/maps/documentation/places/ios-sdk/reference/swift/Enums/PlaceProperty
- **All Swift SDK Enumerations:** https://developers.google.com/maps/documentation/places/ios-sdk/reference/swift/Enums
- **GitHub Repository:** https://github.com/googlemaps/ios-places-sdk
- **Package Installation Guide:** https://developers.google.com/maps/documentation/places/ios-sdk/start