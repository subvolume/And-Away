# Search Logic Documentation
*And Away iOS Project - Smart Hybrid Search Implementation*

## Overview

The And Away app implements a **smart hybrid search system** that automatically selects the optimal Google Places API based on query characteristics. This approach maximizes performance, minimizes costs, and provides the best user experience.

## 🧠 Hybrid Search Strategy

### Core Principle
**Default to Autocomplete, Switch to Text Search for Location Context**

- **Primary API:** Google Places Autocomplete (90% of searches)
  - Fast response times (~100-200ms)
  - Lower cost (~$2.83 per 1000 requests)
  - Excellent for simple queries and search-as-you-type

- **Secondary API:** Google Places Text Search (Location-specific searches)
  - Comprehensive location data (~200-500ms)
  - Higher cost (~$32 per 1000 requests)
  - Superior location intelligence and context handling

## 🎯 Decision Logic

### Algorithm
```swift
func smartSearch(query: String) -> APIChoice {
    if hasLocationContext(query) {
        return .textSearch    // Location-aware results
    } else {
        return .autocomplete  // Fast predictions
    }
}
```

### Location Context Detection
The system detects location context using keyword matching:

```swift
private func hasLocationContext(_ query: String) -> Bool {
    let locationKeywords = ["near me", "nearby", "near", "in ", "around"]
    return locationKeywords.contains { keyword in
        query.lowercased().contains(keyword)
    }
}
```

## 📋 Search Examples

### Autocomplete API Usage (⚡ Fast & Cheap)

| Query | Reason | Expected Results |
|-------|--------|------------------|
| `"coffee"` | Simple category | Coffee shops near default location |
| `"starbucks"` | Brand name | Starbucks locations |
| `"restaurant"` | Category search | Restaurant suggestions |
| `"albert heijn"` | Local brand | Albert Heijn stores |
| `"c"` → `"co"` → `"coffee"` | Search-as-you-type | Progressive predictions |

### Text Search API Usage (🎯 Location-Aware)

| Query | Reason | Expected Results |
|-------|--------|------------------|
| `"coffee near me"` | "near me" keyword | Coffee shops near user location |
| `"restaurants nearby"` | "nearby" keyword | Nearby restaurants with full details |
| `"pizza in amsterdam"` | "in " keyword | Pizza places in Amsterdam |
| `"starbucks near central"` | "near" keyword | Starbucks near Central Station |
| `"hotels around dam square"` | "around" keyword | Hotels around Dam Square |

## 🏗️ Technical Implementation

### GooglePlacesService Structure

```swift
class GooglePlacesService {
    // MARK: - Smart Search (Hybrid Approach)
    func smartSearch(query: String) async throws -> [GooglePlace] {
        if hasLocationContext(query) {
            print("🎯 Using Text Search API for: '\(query)'")
            return try await textSearch(query: query)
        } else {
            print("⚡ Using Autocomplete API for: '\(query)'")
            return try await autocomplete(query: query)
        }
    }
    
    private func hasLocationContext(_ query: String) -> Bool {
        let locationKeywords = ["near me", "nearby", "near", "in ", "around"]
        return locationKeywords.contains { keyword in
            query.lowercased().contains(keyword)
        }
    }
}
```

### API Configuration

**Autocomplete API:**
```
GET https://maps.googleapis.com/maps/api/place/autocomplete/json
?input={query}
&location=52.678606347967175,4.698801550831957
&radius=5000
&sessiontoken={uuid}
&key={apiKey}
```

**Text Search API:**
```
GET https://maps.googleapis.com/maps/api/place/textsearch/json
?query={query}
&location=52.678606347967175,4.698801550831957
&radius=5000
&key={apiKey}
```

### Response Handling

Both APIs return consistent `GooglePlace` objects with appropriate data:

- **Autocomplete Response:** Place predictions without coordinates
- **Text Search Response:** Complete place data with coordinates, ratings, photos
- **Place Details API:** Rich details available for both via `placeDetails(placeId:)`

## 📊 Performance Characteristics

### Response Time Comparison

| API | Typical Response Time | Use Case |
|-----|----------------------|----------|
| Autocomplete | 100-200ms | Search-as-you-type, real-time suggestions |
| Text Search | 200-500ms | Complete search results, location queries |

### Cost Optimization

| API | Cost per 1000 Requests | Savings |
|-----|------------------------|---------|
| Autocomplete | ~$2.83 | 91% cheaper than Text Search |
| Text Search | ~$32.00 | Used only when location context needed |

**Estimated Cost Savings:** 85-90% reduction in API costs compared to Text Search-only approach.

## 🧪 Testing Strategy

### Automated Testing (GooglePlacesServiceTest)

The testing interface validates smart search behavior:

```swift
// Search-as-you-type automatically uses smart search
onChange(of: searchText) {
    if searchAsYouType {
        performSearch() // Uses smartSearch()
    }
}

// Manual search button
Button("Search") {
    performManualSearch() // Uses smartSearch()
}
```

### Test Cases

**Validation Queries:**
1. **Simple Queries:** Verify Autocomplete selection
   - `"coffee"`, `"restaurant"`, `"starbucks"`
2. **Location Queries:** Verify Text Search selection
   - `"coffee near me"`, `"restaurants nearby"`, `"pizza in amsterdam"`
3. **Edge Cases:** Boundary conditions
   - `"starbucks near"` (should use Text Search)
   - `"coffee shop"` (should use Autocomplete)

### Console Output

Debug information shows API selection:
```
⚡ Using Autocomplete API for: 'coffee'
🎯 Using Text Search API for: 'coffee near me'
✅ Smart Search Success: 8 results for 'coffee near me'
```

## 🌍 International Support

### Current Implementation
- **Location Keywords:** English-focused (`"near me"`, `"nearby"`, `"in "`, `"around"`)
- **Geographic Coverage:** Global through Google's location intelligence
- **Coordinate Context:** Netherlands (52.678606347967175, 4.698801550831957)

### Future Enhancements
- **Multi-language Keywords:** Dutch (`"bij"`), French (`"près"`), German (`"nähe"`)
- **User Location Integration:** Dynamic coordinates based on device location
- **Regional Optimization:** Adjust keyword sets based on user locale

## 🚀 Performance Optimizations

### Current Optimizations
- **Session Tokens:** Autocomplete API uses session tokens for cost reduction
- **Request Debouncing:** 0.5-second delay for search-as-you-type
- **Smart API Selection:** Automatic cost optimization
- **Error Handling:** Proper API status checking and error recovery

### Planned Optimizations
- **Request Cancellation:** Cancel previous requests when new search initiated
- **Result Caching:** Cache appropriate results within Google ToS limits
- **Parallel Processing:** Consider parallel API calls with quality-based selection

## 📈 Success Metrics

### Performance Targets
- **Autocomplete Response:** <200ms average
- **Text Search Response:** <400ms average
- **API Selection Accuracy:** >95% correct API choice
- **Cost Reduction:** >85% savings vs Text Search-only

### User Experience Goals
- **Search-as-you-type:** Responsive real-time suggestions
- **Location Searches:** Accurate local results
- **International Usage:** Consistent behavior globally
- **Error Handling:** Graceful fallbacks and user feedback

## 🔄 Evolution Path

### Phase 1: ✅ Current Implementation
- Basic keyword detection
- Simple hybrid approach
- Netherlands location context

### Phase 2: 🔄 Enhanced Intelligence
- Category recognition (`"rest"` → `"Restaurant"`)
- Improved international support
- Request cancellation

### Phase 3: 📋 Advanced Features
- Machine learning-based API selection
- User behavior analysis
- Dynamic location context
- A/B testing infrastructure

## 🛠️ Maintenance Notes

### Monitoring Requirements
- **API Usage:** Track Autocomplete vs Text Search request ratios
- **Response Times:** Monitor performance across both APIs
- **Error Rates:** Watch for API failures or timeouts
- **Cost Analysis:** Regular review of Google Places API billing

### Code Maintenance
- **Keyword Updates:** Add new location keywords based on user data
- **Location Updates:** Adjust default coordinates as needed
- **Performance Tuning:** Optimize based on real usage patterns
- **Testing:** Maintain comprehensive test coverage for both APIs

---

*This document should be updated as the search logic evolves and new features are added to the And Away project.* 