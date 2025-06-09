import Foundation
import SwiftUI
import CoreLocation

// MARK: - Search View Model
@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [PlaceSearchResult] = []
    @Published var autocompleteResults: [AutocompletePrediction] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let googleAPI = GoogleAPIService.shared
    private var searchTask: Task<Void, Never>?
    private var autocompleteTask: Task<Void, Never>?
    
    // Optional location for biasing search results
    var userLocation: CLLocation?
    
    // MARK: - Search for Places
    func searchPlaces() {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            searchResults = []
            return
        }
        
        // Cancel any existing search task
        searchTask?.cancel()
        
        isLoading = true
        errorMessage = nil
        
        searchTask = Task {
            do {
                // Prepare location bias if available
                let locationString: String? = {
                    if let location = userLocation {
                        return "\(location.coordinate.latitude),\(location.coordinate.longitude)"
                    }
                    return nil
                }()
                
                // Use the new optimized search method that automatically fetches Place Details
                let searchResults = try await googleAPI.searchPlacesWithDetails(
                    query: searchText,
                    location: locationString,
                    radius: locationString != nil ? 10000 : nil, // 10km radius if location available
                    maxResults: 10
                )
                
                if !Task.isCancelled {
                    if !searchResults.isEmpty {
                        self.searchResults = searchResults
                    } else {
                        // Fallback to autocomplete + place details if text search returns no results
                        let autocompleteResponse = try await googleAPI.getPlaceAutocomplete(query: searchText)
                        let fallbackResults = await fetchPlaceDetailsForPredictions(autocompleteResponse.predictions.prefix(10))
                        
                        if !Task.isCancelled {
                            self.searchResults = fallbackResults
                        }
                    }
                }
                
            } catch {
                if !Task.isCancelled {
                    errorMessage = "Search failed: \(error.localizedDescription)"
                    searchResults = []
                }
            }
            
            if !Task.isCancelled {
                isLoading = false
            }
        }
    }
    
    // MARK: - Get Autocomplete Suggestions (with debouncing)
    func getAutocompleteSuggestions() {
        guard searchText.count > 2 else {
            autocompleteResults = []
            return
        }
        
        // Cancel any existing autocomplete task
        autocompleteTask?.cancel()
        
        autocompleteTask = Task {
            // Add a small delay to debounce the API calls
            try? await Task.sleep(nanoseconds: 300_000_000) // 300ms delay
            
            guard !Task.isCancelled else { return }
            
            do {
                let response = try await googleAPI.getPlaceAutocomplete(query: searchText)
                
                if !Task.isCancelled {
                    autocompleteResults = response.predictions
                }
            } catch {
                if !Task.isCancelled {
                    // For autocomplete, we don't show errors to the user - just log them
                    print("Autocomplete failed: \(error.localizedDescription)")
                    autocompleteResults = []
                }
            }
        }
    }
    
    // MARK: - Search from Autocomplete Selection
    func searchFromAutocomplete(_ prediction: AutocompletePrediction) {
        searchText = prediction.description
        
        // Clear autocomplete and start search
        autocompleteResults = []
        searchPlaces()
    }
    
    // MARK: - Get Place Details
    func getPlaceDetails(placeId: String) async -> PlaceDetails? {
        do {
            let response = try await googleAPI.getPlaceDetails(placeId: placeId)
            return response.result
        } catch {
            print("Failed to get place details: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Clear Search
    func clearSearch() {
        searchText = ""
        searchResults = []
        autocompleteResults = []
        errorMessage = nil
        
        // Cancel any ongoing tasks
        searchTask?.cancel()
        autocompleteTask?.cancel()
    }
    
    // MARK: - Fetch Place Details for Autocomplete Results
    private func fetchPlaceDetailsForPredictions(_ predictions: ArraySlice<AutocompletePrediction>) async -> [PlaceSearchResult] {
        var results: [PlaceSearchResult] = []
        
        // Fetch place details for each prediction (in parallel for better performance)
        await withTaskGroup(of: PlaceSearchResult?.self) { group in
            for prediction in predictions {
                group.addTask {
                    guard let placeDetails = await self.getPlaceDetails(placeId: prediction.placeId) else {
                        return nil
                    }
                    
                    // Convert PlaceDetails to PlaceSearchResult with real data
                    return PlaceSearchResult(
                        placeId: placeDetails.placeId,
                        name: placeDetails.name,
                        vicinity: nil, // PlaceDetails doesn't have vicinity, so set to nil
                        formattedAddress: placeDetails.formattedAddress,
                        addressComponents: placeDetails.addressComponents,
                        rating: placeDetails.rating,
                        priceLevel: placeDetails.priceLevel,
                        photos: placeDetails.photos,
                        geometry: placeDetails.geometry,
                        types: placeDetails.types,
                        userRatingsTotal: placeDetails.userRatingsTotal,
                        businessStatus: placeDetails.businessStatus
                    )
                }
            }
            
            // Collect results in order
            for await result in group {
                if let searchResult = result {
                    results.append(searchResult)
                }
            }
        }
        
        return results
    }
    
    // MARK: - Cancel Tasks on Deinit
    deinit {
        searchTask?.cancel()
        autocompleteTask?.cancel()
    }
}

// MARK: - Search State
enum SearchState {
    case empty
    case searching
    case results([PlaceSearchResult])
    case error(String)
} 