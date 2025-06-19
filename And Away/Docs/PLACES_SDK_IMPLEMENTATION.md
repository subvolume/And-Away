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
- [ ] **Create Places Service Protocol**
   - Centralize all SDK calls in one thin wrapper
   - Easy to stub for testing, update if Google changes API
   ```swift
   protocol PlacesService {
       func searchPlaces(query: String) async -> Result<[Place], PlacesError>
       func fetchPlace(placeID: String) async -> Result<[Place], PlacesError>
   }
   ```
   - [ ] **Verification:** A new Swift file exists containing the `PlacesService` protocol definition.

- [ ] **Wire Up Search Results**
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
   - [ ] **Verification:** Searching in the UI displays a list of real places instead of placeholder data.

- [ ] **Connect Place Selection**
   - Pass only `placeID` strings between views (lightweight, Codable)
   - Fresh data fetch in details view ensures up-to-date information
   - Simplifies navigation state and persistence
   - [ ] **Verification:** Tapping a search result item opens the details sheet for the correct place.

### Phase 3: Place Details
- [ ] **Implement Place Details View**
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
   - [ ] **Verification:** The details view shows real content (address, photos, etc.) for the selected place.

### Phase 4: Map Integration
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