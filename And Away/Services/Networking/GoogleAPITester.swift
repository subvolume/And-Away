import Foundation

// MARK: - Simple Google API Tester
class GoogleAPITester {
    private let googleAPI = GoogleAPIService.shared
    
    // MARK: - Test Place Autocomplete
    func testAutocomplete() {
        Task {
            do {
                print("🔍 Testing Google Places Autocomplete...")
                let response = try await googleAPI.getPlaceAutocomplete(query: "coffee shop")
                
                print("✅ Success! Found \(response.predictions.count) suggestions:")
                for prediction in response.predictions.prefix(3) {
                    print("   • \(prediction.description)")
                }
                
            } catch {
                print("❌ Autocomplete failed: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Test Place Details
    func testPlaceDetails(placeId: String) {
        Task {
            do {
                print("📍 Testing Google Place Details...")
                let response = try await googleAPI.getPlaceDetails(placeId: placeId)
                
                print("✅ Success! Place details:")
                print("   • Name: \(response.result.name)")
                print("   • Address: \(response.result.formattedAddress ?? "No address")")
                print("   • Rating: \(response.result.rating ?? 0)/5")
                
            } catch {
                print("❌ Place details failed: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Test Text Search
    func testTextSearch() {
        Task {
            do {
                print("🔍 Testing Google Places Text Search...")
                let response = try await googleAPI.searchPlacesByText(query: "restaurants in Paris")
                
                print("✅ Success! Found \(response.results.count) places:")
                for place in response.results.prefix(3) {
                    print("   • \(place.name) - \(place.vicinity ?? "Unknown location")")
                    print("     Rating: \(place.rating ?? 0)/5 (\(place.userRatingsTotal ?? 0) reviews)")
                }
                
            } catch {
                print("❌ Text search failed: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Test Directions
    func testDirections() {
        Task {
            do {
                print("🗺️ Testing Google Directions...")
                let response = try await googleAPI.getDirections(
                    origin: "New York, NY",
                    destination: "Brooklyn, NY"
                )
                
                if let firstRoute = response.routes.first {
                    print("✅ Success! Direction found:")
                    print("   • Distance: \(firstRoute.legs.first?.distance.text ?? "Unknown")")
                    print("   • Duration: \(firstRoute.legs.first?.duration.text ?? "Unknown")")
                    print("   • Summary: \(firstRoute.summary)")
                }
                
            } catch {
                print("❌ Directions failed: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Run All Tests
    func runAllTests() {
        print("🚀 Starting Google API Tests...\n")
        
        // Test 1: Autocomplete
        testAutocomplete()
        
        // Test 2: Text Search
        testTextSearch()
        
        // Test 3: Directions
        testDirections()
        
        // Note: Place details test requires a place ID from autocomplete
        print("\n💡 To test place details, run testPlaceDetails(placeId:) with a place ID from autocomplete results")
    }
} 