import Foundation
import SwiftUI

// MARK: - Search View Model
@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [PlaceSearchResult] = []
    @Published var autocompleteResults: [AutocompletePrediction] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let googleAPI = GoogleAPIService.shared
    
    // MARK: - Search for Places
    func searchPlaces() {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            searchResults = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                // For now, we'll use autocomplete to get places
                // Later we can add proper place search with coordinates
                let response = try await googleAPI.getPlaceAutocomplete(query: searchText)
                
                // Convert autocomplete results to search results
                // This is a simplified approach - in a real app you'd get full place details
                searchResults = await convertPredictionsToSearchResults(response.predictions)
                
            } catch {
                errorMessage = "Search failed: \(error.localizedDescription)"
                searchResults = []
            }
            
            isLoading = false
        }
    }
    
    // MARK: - Get Autocomplete Suggestions
    func getAutocompleteSuggestions() {
        guard searchText.count > 2 else {
            autocompleteResults = []
            return
        }
        
        Task {
            do {
                let response = try await googleAPI.getPlaceAutocomplete(query: searchText)
                autocompleteResults = response.predictions
            } catch {
                print("Autocomplete failed: \(error.localizedDescription)")
                autocompleteResults = []
            }
        }
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
    }
    
    // MARK: - Helper: Convert Predictions to Search Results
    private func convertPredictionsToSearchResults(_ predictions: [AutocompletePrediction]) async -> [PlaceSearchResult] {
        var results: [PlaceSearchResult] = []
        
        // Convert first 10 predictions to search results
        for prediction in predictions.prefix(10) {
            // Create a basic search result from prediction
            // In a real implementation, you'd fetch full details for each place
            let searchResult = PlaceSearchResult(
                placeId: prediction.placeId,
                name: prediction.structuredFormatting.mainText,
                vicinity: prediction.structuredFormatting.secondaryText,
                rating: nil, // Would get from place details
                priceLevel: nil,
                photos: nil,
                geometry: PlaceGeometry(
                    location: PlaceLocation(lat: 0, lng: 0), // Would get from place details
                    viewport: nil
                ),
                types: prediction.types,
                userRatingsTotal: nil,
                businessStatus: nil
            )
            results.append(searchResult)
        }
        
        return results
    }
}

// MARK: - Search State
enum SearchState {
    case empty
    case searching
    case results([PlaceSearchResult])
    case error(String)
} 