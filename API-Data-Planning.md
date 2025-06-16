# API & Data Implementation Planning
*And Away iOS Project*

## 1. Current State Analysis

### Existing Implementation Status:
- **Google Places Models**: Placeholder implementations to be replaced
- **MockData**: Temporary data for development - will be replaced
- **Architecture**: Currently Google-specific, migrating to provider-agnostic design

### What We're Replacing:
- `GooglePlaceDetailsModels.swift`
- `GooglePlacesSearchModels.swift` 
- `GoogleAutocompleteModels.swift`
- `GoogleDirectionsModels.swift`
- `MockData.swift`

### Migration Strategy:
- Replace Google-specific models with generic protocols
- Implement both Apple MapKit and Google Places as concrete services
- Maintain existing UI components and ViewModels


## 2. Google Places API Integration

### What Google Places API Offers:
**Rich, global place data with strong business information**

### Core Services for Your App:
- **Text Search** - "coffee shops near me" → list of results
- **Nearby Search** - Find places around a location by category
- **Place Details** - Full info (photos, reviews, hours, phone, website)
- **Autocomplete** - Smart search suggestions as user types
- **Place Photos** - High-quality images of businesses
- **Reviews & Ratings** - User-generated content and scores

### Google's Strengths:
- ✅ **Global Coverage** - Excellent worldwide data
- ✅ **Business Info** - Hours, phone numbers, websites very accurate
- ✅ **Rich Photos** - High-quality images from businesses and users  
- ✅ **Business Data** - Accurate hours, contact info, website details
- ✅ **Search Quality** - Very intelligent text-based search

### Potential Challenges:
- 💰 **Cost** - Can get expensive with heavy usage
- 🔧 **Complexity** - More setup (API keys, billing, quotas)
- 📱 **iOS Integration** - Less native iOS integration than MapKit
- ⚡ **Performance** - Network calls vs local Apple data

### Integration with Your Architecture:
```swift
// GooglePlacesService.swift - implements your protocols
class GooglePlacesService: PlacesSearchService, PlaceDetailsService {
    // Maps Google responses to your generic Place models
    // Handles API keys, rate limiting, error handling
}
```

### Your Requirements Analysis:
- ✅ **Worldwide Coverage** - Google excels here vs Apple's more limited international data
- ✅ **Rich Business Data** - Google's strength (photos, detailed hours, contact info)
- ✅ **Search Quality** - Very intelligent text-based search

### Recommended Approach for Your Needs:
**Google Places API is likely your best choice because:**
1. **Global reach** - Apple MapKit has limited data outside major markets
2. **Business richness** - Google's photos and business details are superior
3. **Your abstraction layer** - Easy to switch later if needed

### Implementation Benefits:
- Cache place details in iCloud after first fetch for offline access
- Batch nearby searches when possible for efficiency
- Progressive loading (basic info first, details on demand)


## 3. Data Flow Architecture

### Provider-Agnostic Design
**Goal**: Create abstraction layer to easily switch between Apple MapKit and Google Places API

### Architecture Layers:
1. **Protocol Layer** - Defines standard interface for location services
2. **Service Implementations** - Concrete implementations for each provider
3. **ViewModels** - Provider-agnostic, only interact with protocols
4. **Easy Provider Switching** - Single configuration change

### Key Protocols Needed:
- `PlacesSearchService` - Search for places
- `PlaceDetailsService` - Get detailed place information  
- `DirectionsService` - Navigation and routing
- `LocationService` - Current location and geocoding

### Benefits:
- ✅ Test both Apple & Google implementations
- ✅ Compare performance, cost, and features
- ✅ Future-proof for additional providers
- ✅ Clean ViewModel separation
- ✅ A/B testing capabilities


## 4. Storage Strategy

### Primary Storage: iCloud
**Seamless sync across user's devices**

- **Core Data + CloudKit** integration
- Automatic sync between iPhone, iPad, Mac
- User data stays private and secure
- No additional accounts or sign-ups required

### Data to Store:
- **Bookmarks with Notes** - User's saved places + personal annotations
- **Search History** - Recent searches and results
- **Custom Lists** - User-created collections ("Weekend Spots", "Restaurants to Try")
- **User Preferences** - Category filters, map settings
- **Cached Place Data** - Offline access to frequently viewed places

### Bookmark Model Structure:
```swift
struct Bookmark {
    let id: UUID                            // Unique bookmark ID
    let place: Place                        // The saved place
    let userNote: String                    // User's personal note
    let dateBookmarked: Date               // When it was saved
    let tags: [String]                     // Optional user tags
    let listMembership: [UUID]             // Which custom lists it belongs to
}

// User can write notes like:
// "Amazing pasta! Go for the carbonara. Ask for table by the window."
// "Potential venue for anniversary dinner - call ahead"
// "Great coffee but limited seating. Best around 10am."
```

### Personal Data Benefits:
- 📝 **Memory aid** - Users remember why they saved places
- 🏷️ **Personal context** - Add details not in official descriptions
- 📚 **Personal travel guide** - Build their own recommendations
- 🔄 **Easy reference** - Quick notes for future visits

### Export Functionality:
**Give users control over their data**

```swift
// Export formats to support
enum ExportFormat {
    case json          // Developer-friendly
    case csv           // Spreadsheet compatible  
    case kml           // Google Earth/Maps compatible
    case gpx           // GPS/navigation apps
}
```

### Export Features:
- Export all data or specific lists
- Multiple format options for different use cases
- Share via standard iOS sharing sheet
- Import to other travel/map apps

### Benefits:
- 🔄 Seamless multi-device experience
- 🔒 Privacy-focused (user's iCloud, not our servers)
- 📤 Data portability and ownership
- 💾 Offline access to important data


## 5. API Endpoints Planning

### Core Protocols for Provider-Agnostic Design

### 1. PlacesSearchService Protocol
```swift
protocol PlacesSearchService {
    // Text-based search: "coffee shops in paris"
    func searchPlaces(query: String, location: CLLocation?, radius: Double?) async throws -> [Place]
    
    // Category-based search around location
    func searchNearby(location: CLLocation, categories: [PlaceCategory], radius: Double) async throws -> [Place]
    
    // Search within specific bounds/area
    func searchInRegion(query: String?, region: MKCoordinateRegion, categories: [PlaceCategory]?) async throws -> [Place]
}
```

### 2. PlaceDetailsService Protocol  
```swift
protocol PlaceDetailsService {
    // Get full details for a place
    func getPlaceDetails(placeId: String) async throws -> PlaceDetails
    
    // Get photos for a place
    func getPlacePhotos(placeId: String, maxPhotos: Int) async throws -> [PlacePhoto]
}
```

### 3. AutocompleteService Protocol
```swift
protocol AutocompleteService {
    // Search suggestions as user types
    func getAutocompleteSuggestions(input: String, location: CLLocation?, radius: Double?) async throws -> [AutocompleteSuggestion]
    
    // Get place from autocomplete selection
    func getPlaceFromSuggestion(suggestion: AutocompleteSuggestion) async throws -> Place
}
```

### 4. DirectionsService Protocol
```swift
protocol DirectionsService {
    // Get directions between two points
    func getDirections(from: CLLocation, to: CLLocation, travelMode: TravelMode) async throws -> Route
    
    // Get multiple route options
    func getRouteAlternatives(from: CLLocation, to: CLLocation, travelMode: TravelMode) async throws -> [Route]
}
```

### 5. LocationService Protocol
```swift
protocol LocationService {
    // Current user location
    func getCurrentLocation() async throws -> CLLocation
    
    // Reverse geocoding: coordinates → address
    func getAddress(for location: CLLocation) async throws -> Address
    
    // Forward geocoding: address → coordinates  
    func getLocation(for address: String) async throws -> CLLocation
}
```

### Implementation Mapping:

#### Google Places API → Protocols:
- **Text Search API** → `searchPlaces()`
- **Nearby Search API** → `searchNearby()`
- **Place Details API** → `getPlaceDetails()`
- **Place Photos API** → `getPlacePhotos()`
- **Autocomplete API** → `getAutocompleteSuggestions()`
- **Directions API** → `getDirections()`

#### Apple MapKit → Protocols:
- **MKLocalSearch** → `searchPlaces()`, `searchNearby()`
- **MKMapItem** → `getPlaceDetails()`
- **CLGeocoder** → `getAddress()`, `getLocation()`
- **MKDirections** → `getDirections()`
- **Limited photos** → Fallback implementations


## 6. Data Models Structure

### Core Place Model Requirements
**Essential data fields needed for the app:**

```swift
struct Place {
    let id: String                          // Unique identifier
    let name: String                        // Name of place
    let location: CLLocation                // Coordinates for map plotting
    let locality: String                    // City/area name
    let category: PlaceCategory             // Standardized category
    let isOpen: OpenStatus?                 // Open/closed status
    let photos: [PlacePhoto]                // Place images
    let distanceFromUser: Double?           // Distance in meters
    let address: String                     // Full address
    let phoneNumber: String?                // Contact number
    let website: URL?                       // Official website
    let googleMapsLink: URL?                // Google Maps link
    let tripadvisorLink: URL?               // TripAdvisor link
}

enum OpenStatus {
    case open
    case closed
    case unknown
    case openUntil(Date)
    case opensAt(Date)
}

struct TravelInfo {
    let walkingTime: TimeInterval?          // Walking duration
    let walkingRoute: Route?                // Walking directions
    let drivingTime: TimeInterval?          // Driving duration  
    let drivingRoute: Route?                // Driving directions
    let transitTime: TimeInterval?          // Public transport duration
    let transitRoute: Route?                // Public transport directions
}
```

### Supporting Models
- `PlacePhoto` - Image URLs and metadata
- `PlaceCategory` - Standardized categories with visual styling
- `Route` - Turn-by-turn directions and polylines
- `Address` - Structured address components

### Search Result Scoring Model
**Configurable scoring system for ranking search results**

```swift
struct SearchResultScorer {
    // Named weights - can be adjusted for optimization
    struct ScoringWeights {
        let distanceWeight: Double = 0.25          // Closer = better
        let popularityWeight: Double = 0.20        // Higher rated = better
        let queryRelevanceWeight: Double = 0.30    // Text match quality
        let categoryMatchWeight: Double = 0.15     // Category filter match
        let businessStatusWeight: Double = 0.05    // Open vs closed
        let dataCompletenessWeight: Double = 0.05  // Has photos, phone, etc.
    }
    
    static func calculateScore(for place: Place, query: SearchQuery, userLocation: CLLocation?) -> Double
}

struct SearchQuery {
    let text: String?                              // User's search text
    let categories: [PlaceCategory]                // Filtered categories
    let location: CLLocation?                      // Search center point
    let maxDistance: Double?                       // Search radius
}

struct SearchResult {
    let place: Place                               // The actual place
    let matchType: SearchMatchType                 // How this result matched
    let relevanceScore: Double                     // Calculated relevance (0-1)
    let distanceFromUser: Double?                  // Distance in meters
    let searchContext: SearchContext               // Location context
}

enum SearchMatchType {
    case exactNameMatch                            // "Starbucks" → "Starbucks Coffee"
    case partialNameMatch                          // "coffee" → "Blue Bottle Coffee"
    case categoryMatch                             // "restaurant" → restaurants near user
    case savedPlace                                // User's bookmarked places
    case nearbyDiscovery                          // New places near user location
    case globalSearch                              // Results outside user's immediate area
}

struct SearchContext {
    let userLocation: CLLocation?                  // User's current position
    let searchOrigin: CLLocation?                  // Where the search is centered
    let searchRadius: Double                       // Effective search radius
    let locationAccuracy: CLLocationAccuracy       // GPS accuracy
    let isLocationRecent: Bool                     // Is location data fresh
}

// Organized search results
struct OrganizedSearchResults {
    let exactMatches: [SearchResult]               // Perfect name matches
    let savedPlaces: [SearchResult]                // User's bookmarks that match
    let nearbyResults: [SearchResult]              // Results within close radius
    let categoryMatches: [SearchResult]            // Category-based matches
    let extendedResults: [SearchResult]            // Results from wider search
    let searchContext: SearchContext               // Context for this search
}

// Scoring factors:
enum ScoringFactor {
    case distance(meters: Double)                  // 0-1 (closer = higher)
    case popularity(rating: Double, reviewCount: Int) // 0-1 (popular = higher)
    case queryRelevance(score: Double)            // 0-1 (text similarity)
    case categoryMatch(isExactMatch: Bool)        // 0-1 (exact match = 1)
    case businessStatus(isOpen: Bool)             // 0-1 (open = 1)
    case dataCompleteness(completionRatio: Double) // 0-1 (complete = 1)
}
```

### Scoring Benefits:
- 🎯 **Configurable ranking** - Adjust weights based on user feedback
- 📊 **A/B testing** - Try different weight combinations
- 🔧 **Context-aware** - Different weights for different search types
- 📈 **Optimizable** - Improve results over time based on user behavior
- 🎛️ **Controllable** - Fine-tune for specific use cases (nearby vs text search)

### Category Management System
**Centralized category definitions with visual properties**

```swift
// CategoryDefinition.swift
struct CategoryDefinition {
    let id: String
    let displayName: String
    let icon: String           // SF Symbol name
    let color: Color          // Brand color
    let priority: Int         // Display order
}
```

### Category Mapping Strategy:
**Comprehensive category support for all provider types**

- **Apple Categories** → `StandardCategory` ← **Google Categories**
- Map ALL categories from both providers (not just common ones)
- Fallback system for unknown/new categories
- Extensible design for future category additions

### Implementation Approach:
```swift
// CategoryRegistry.swift
class CategoryRegistry {
    // Predefined mappings for known categories
    static let knownCategories: [String: CategoryDefinition]
    
    // Fallback generator for unmapped categories
    static func generateFallback(for rawCategory: String) -> CategoryDefinition
    
    // Dynamic category resolution
    static func resolve(_ providerCategory: String, provider: DataProvider) -> CategoryDefinition
}
```

### Handling Strategy:
1. **Known Categories**: Use predefined styling (restaurants, hotels, etc.)
2. **Unknown Categories**: Generate consistent fallback styling
3. **Provider-Specific**: Handle unique categories from each provider
4. **Future-Proof**: Easy to add new mappings as providers expand

### Benefits:
- 🎨 Consistent branding regardless of data source
- 🔧 Easy maintenance - change icon/color in one place
- 📱 Better UX - users see familiar visual patterns
- 🗂️ Standardized category system


## 7. Implementation Roadmap

### Phase 1: Foundation Architecture (Week 1-2)
**Build the core abstraction layer**

1. **Create Protocol Definitions**
   - Define `PlacesSearchService`, `PlaceDetailsService`, `AutocompleteService` protocols
   - Create base data models: `Place`, `PlaceCategory`, `SearchResult`
   - Set up `SearchResultScorer` framework

2. **Category Management System**
   - Create `CategoryDefinition` and `CategoryRegistry`
   - Define initial category mappings (restaurants, hotels, gas stations, etc.)
   - Implement fallback system for unknown categories

3. **Mock Implementation**
   - Build `MockPlacesService` for development/testing
   - Create sample data using existing `MockData.swift` as reference
   - Enable UI development without API dependencies

### Phase 2: Google Places Integration (Week 3-4)
**Implement the primary data provider**

1. **Google Places Service Setup**
   - Set up Google Places API credentials and SDK
   - Create `GooglePlacesService` implementing all protocols
   - Handle API key management and basic error handling

2. **Data Mapping & Transformation**
   - Map Google responses to generic `Place` models
   - Implement category translation (Google types → standard categories)
   - Handle missing data gracefully with fallbacks

3. **Basic Search Implementation**
   - Implement text search and nearby search
   - Add autocomplete functionality
   - Test with real API responses

### Phase 3: Search Intelligence (Week 5-6)
**Build the smart search and scoring system**

1. **Search Result Organization**
   - Implement `OrganizedSearchResults` structure
   - Create search context handling with location awareness
   - Build search result categorization logic

2. **Scoring System Implementation**
   - Implement configurable scoring weights
   - Create scoring algorithms for each factor
   - Add A/B testing framework for weight optimization

3. **Location Intelligence**
   - Integrate user location services
   - Handle location permissions and accuracy
   - Implement distance calculations and context awareness

### Phase 4: Storage & Persistence (Week 7-8)
**Add iCloud sync and bookmark functionality**

1. **Core Data + CloudKit Setup**
   - Design Core Data model for bookmarks and user data
   - Configure CloudKit integration for seamless sync
   - Handle sync conflicts and offline scenarios

2. **Bookmark System**
   - Implement bookmark creation with user notes
   - Create custom lists functionality
   - Add tags and organization features

3. **Caching Strategy**
   - Cache frequently accessed place details
   - Implement search history storage
   - Handle cache invalidation and updates

### Phase 5: UI Integration (Week 9-10)
**Connect the backend to existing UI components**

1. **ViewModel Updates**
   - Update existing ViewModels to use new protocol-based services
   - Implement search result presentation logic
   - Add bookmark management functionality

2. **Enhanced Search UI**
   - Update search components to handle organized results
   - Add category filtering and context display
   - Implement bookmark notes and tagging UI

3. **Map Integration**
   - Connect place data to map annotations
   - Add search result visualization on map
   - Implement place detail sheets

### Phase 6: Apple MapKit Alternative (Week 11-12)
**Build the alternative provider for comparison**

1. **Apple MapKit Service**
   - Create `AppleMapKitService` implementing same protocols
   - Handle MapKit limitations (fewer photos, basic business data)
   - Implement fallback strategies for missing features

2. **Provider Switching**
   - Create configuration system for easy provider switching
   - Add debug/settings UI for testing different providers
   - Implement side-by-side comparison tools

### Phase 7: Export & Polish (Week 13-14)
**Complete the feature set and optimize**

1. **Export Functionality**
   - Implement JSON, CSV, KML, GPX export formats
   - Add sharing capabilities through iOS share sheet
   - Test export/import workflows

2. **Performance Optimization**
   - Optimize API call patterns and caching
   - Implement request batching where possible
   - Add performance monitoring and analytics

3. **Testing & Refinement**
   - Comprehensive testing of both providers
   - User experience testing and refinement
   - Documentation and final polish

### Quality Assurance & Testing Strategy:

#### Each Phase Must Include:
1. **Architecture Review** - Code structure evaluation before proceeding
2. **Unit Tests** - Core functionality tested with automated tests
3. **Integration Testing** - Components work together properly
4. **User Testing** - You test functionality and provide feedback
5. **Refactoring Check** - Clean up any technical debt before next phase

#### Phase Gates (Must Pass Before Proceeding):
- **Phase 1 Gate**: Protocols compile, mock data works, architecture is clean
- **Phase 2 Gate**: Google API integration tested, data mapping verified, error handling works
- **Phase 3 Gate**: Search results properly organized, scoring system validated
- **Phase 4 Gate**: iCloud sync works, bookmarks persist, offline handling tested
- **Phase 5 Gate**: UI integration complete, user workflows validated

#### Architectural Validation Points:
```swift
// Example: Phase 1 must demonstrate this works cleanly
let searchService: PlacesSearchService = MockPlacesService() // or GooglePlacesService()
let results = await searchService.searchPlaces(query: "coffee", location: userLocation)
// Should work identically regardless of implementation
```

#### Testing Approach:
- **Unit Tests**: Each protocol implementation fully tested
- **Integration Tests**: End-to-end search workflows
- **UI Tests**: Critical user paths validated
- **Performance Tests**: API response times and caching effectiveness
- **Edge Case Tests**: Poor network, no location permission, empty results

### Revised Timeline (Quality-First):
- **Week 1**: Foundation + Testing Framework
- **Week 2**: Google Integration + Validation
- **Week 3**: Search Intelligence + User Testing
- **Week 4**: Storage + Integration Testing  
- **Week 5**: UI Integration + End-to-End Testing
- **Week 6**: Polish + Apple Alternative (Optional)

### Key Milestones:
- **Week 1**: Clean architecture foundation with comprehensive testing
- **Week 2**: Fully tested Google Places integration
- **Week 3**: Validated smart search with user feedback
- **Week 4**: Reliable storage system with sync testing
- **Week 5**: Complete, tested app ready for real-world use
- **Week 6**: Alternative provider option available


## 8. Notes & Considerations 