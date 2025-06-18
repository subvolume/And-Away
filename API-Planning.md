# Google Text Search (NEW) API Planning

## Overview

**Why Text Search (NEW) over Autocomplete (NEW):**
- Text Search (NEW) provides more robust data compared to Autocomplete (NEW)
- Returns comprehensive place information in a single API call
- Reduces need for additional Place Details API calls
- More efficient architecture with fewer network requests
- Cost trade-off: ~$0.02 more expensive per user per month vs Autocomplete (NEW)
- Better user experience justifies the small cost increase

**Why Google over Apple MapKit:**
- Apple's MapKit data quality is insufficient for current needs
- Google Places provides more comprehensive and accurate location data

## API Documentation

### What We Need vs What Text Search (NEW) Provides

**Available from Text Search (NEW):**
- ✅ Place name → `places.displayName`
- ✅ Place id → `places.id`
- ✅ Lat/long → `places.location`
- ✅ Address → `places.formattedAddress`
- ✅ City → `places.addressComponents` (need to parse)
- ✅ Category/subcategories → `places.types` + `places.primaryType`
- ✅ Open/closed → `places.currentOpeningHours` + `places.businessStatus`
- ✅ Phone → `places.internationalPhoneNumber`
- ✅ Website → `places.websiteUri`
- ⚠️ Photos → `places.photos` returns photo references, requires separate Place Photos (NEW) API calls

**NOT available from Text Search (NEW) - Need Other APIs:**
- ❌ Distance → Calculate client-side from user location + place location
- ❌ Travel time → Google Routes API
- ⚠️ Photo URLs → Need Place Photos (NEW) API using photo references from `places.photos`

**Future Enhancements:**
- 🔮 External site links (Tripadvisor, OpenTable, etc.) → Third-party APIs or web scraping

### Minimum Field Mask for Our Needs
```
places.displayName,places.id,places.location,places.formattedAddress,places.addressComponents,places.types,places.primaryType,places.currentOpeningHours,places.businessStatus,places.internationalPhoneNumber,places.websiteUri,places.photos
```

## Implementation Plan

### APIs to Enable in Google Cloud Console

**Primary APIs (via Google Places Swift SDK):**
- **Google Places Text Search (NEW)** - Text-based searches like "pizza in New York"
- **Google Places Nearby Search (NEW)** - Category-based searches like "restaurants near me"  
- **Google Place Photos (NEW)** - High-quality place images
- **Google Routes API** - Travel time calculations

**What Each Provides:**
- Place name, ID, location, address, city, category, hours, phone, website
- Photo references and images
- Travel time and distance calculations

**Client-side Calculations:**
- Distance calculation (using lat/long from Places API + user location)

## Data Models

### Official Google Places SDK Integration

**Primary Approach: Use Official Google Places Swift SDK**
- Install `GooglePlacesSwift` via Swift Package Manager from: `https://github.com/googlemaps/ios-places-sdk`
- SDK provides all pre-built models for Text Search (NEW), Nearby Search (NEW), Place Photos (NEW), etc.
- No need to create API-specific models from scratch
- Models are maintained by Google and automatically stay compatible with API updates

**Custom Models to Create:**

**PlaceModels.swift (Unified Domain Model):**
- `Place` - Unified model that represents places throughout our app
- Contains all fields we need: name, ID, location, address, city, category, etc.
- Acts as the single source of truth for place data throughout the app

**PlaceAdapters.swift (Conversion Layer):**
- `GooglePlaceAdapter` - Converts Google SDK models to our unified `Place` model
- Simple mapping functions that extract needed data from Google's models
- Keeps our app decoupled from Google's specific model structure

**PlaceCategorization.swift (Business Logic):**
- Place type categorization and color assignments
- Icon mappings for different place categories  
- Single source of truth for how we display different place types

### Models to Replace/Remove
- `GoogleAutocompleteModels.swift` → Remove (use Google SDK models)
- `GoogleDirectionsModels.swift` → Remove (use Google SDK models)
- `GooglePlaceDetailsModels.swift` → Remove (use Google SDK models)
- `GooglePlacesSearchModels.swift` → Remove (use Google SDK models)
- `MockData.swift` → Update to use Google SDK models + our unified `Place` model

## Service Layer

### Use Google's Official Templates

**Recommended Approach: Start with Google's Sample App**
- Download the official sample project: `https://github.com/googlemaps-samples/ios-places-sdk-samples`
- Contains production-ready service layer implementations
- Includes working examples for Text Search, Nearby Search, Place Details, and Photos
- Uses modern Swift patterns (async/await, error handling, configuration)

**What to Extract from Templates:**
- Service class structures and patterns
- Error handling approaches
- API configuration and setup
- Swift concurrency implementations

**Minimal Customization Needed:**
- Adapt Google's models to our unified `Place` model via simple mappers
- Apply our custom styling to UI components
- Add any app-specific business logic

**Benefits:**
- ✅ **Battle-tested code** - proven in production
- ✅ **Google best practices** - official patterns and approaches  
- ✅ **Time savings** - weeks of development work already done
- ✅ **Future-proof** - maintained by Google as APIs evolve
- ✅ **Minimalist** - start with working code, customize only what's needed

**Next Steps:**
1. Clone the sample repository
2. Run the demo app to understand the patterns
3. Extract the service components that match our needs
4. Integrate with our existing app architecture

## Dependencies
- Google Places Swift SDK (install via Swift Package Manager)
- CoreLocation framework (for user location)
- SwiftUI/UIKit (for UI components)

## Testing Strategy

## Integration Points

## Notes 