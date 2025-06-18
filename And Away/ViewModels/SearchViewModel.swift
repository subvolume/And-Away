import Foundation
import SwiftUI

@MainActor
class SearchViewModel: ObservableObject {
    
    // MARK: - Published Properties (UI State)
    @Published var searchResults: [GooglePlace] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var hasSearched = false
    
    // MARK: - Private Properties
    private let googleService: GooglePlacesService
    private var searchTask: Task<Void, Never>?
    
    // MARK: - Initialization
    init() {
        self.googleService = GooglePlacesService() // Uses Config.googlePlacesAPIKey by default
    }
    
    // MARK: - Public Search Methods
    
    /// Main search method with debouncing and smart logic
    func search(query: String) async {
        // Cancel any existing search
        cancelCurrentSearch()
        
        // Clear results if query is empty
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            clearResults()
            return
        }
        
        // Don't search for very short queries (performance)
        guard query.count >= 2 else {
            return
        }
        
        // Create new search task with debouncing
        searchTask = Task {
            // Debounce: wait before starting search
            try? await Task.sleep(nanoseconds: UInt64(Config.searchDebounceTime * 1_000_000_000))
            
            // Check if task was cancelled during sleep
            guard !Task.isCancelled else { return }
            
            // Perform the actual search
            await performSearch(query: query)
        }
    }
    
    /// Immediate search without debouncing (for manual search button)
    func searchImmediately(query: String) async {
        cancelCurrentSearch()
        
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            clearResults()
            return
        }
        
        await performSearch(query: query)
    }
    
    /// Clear all search results and state
    func clearResults() {
        searchResults = []
        errorMessage = nil
        isLoading = false
        hasSearched = false
    }
    
    /// Cancel current search operation
    func cancelCurrentSearch() {
        searchTask?.cancel()
        searchTask = nil
        isLoading = false
    }
    
    // MARK: - Private Methods
    
    private func performSearch(query: String) async {
        // Update UI state
        isLoading = true
        errorMessage = nil
        
        do {
            // Use smart search (your hybrid approach)
            let results = try await googleService.smartSearch(query: query)
            
            // Check if task was cancelled during API call
            guard !Task.isCancelled else { return }
            
            // Update results
            searchResults = results
            hasSearched = true
            isLoading = false
            
            // Debug logging
            if Config.isDebug {
                print("✅ SearchViewModel: Found \(results.count) results for '\(query)'")
            }
            
        } catch {
            // Check if task was cancelled during error handling
            guard !Task.isCancelled else { return }
            
            // Handle different types of errors
            handleSearchError(error)
            
            // Debug logging
            if Config.isDebug {
                print("❌ SearchViewModel: Search failed for '\(query)': \(error)")
            }
        }
    }
    
    private func handleSearchError(_ error: Error) {
        isLoading = false
        searchResults = []
        
        // Convert technical errors to user-friendly messages
        if let googleError = error as? GooglePlacesError {
            switch googleError {
            case .invalidURL:
                errorMessage = "Invalid search request. Please try again."
            case .noData:
                errorMessage = "No data received. Check your internet connection."
            case .decodingError:
                errorMessage = "Unable to process search results. Please try again."
            case .apiError(let status):
                errorMessage = handleAPIErrorStatus(status)
            }
        } else {
            // Generic network or other errors
            errorMessage = "Search failed. Please check your internet connection and try again."
        }
    }
    
    private func handleAPIErrorStatus(_ status: String) -> String? {
        switch status {
        case "ZERO_RESULTS":
            return nil // Don't show error for no results
        case "OVER_QUERY_LIMIT":
            return "Search limit reached. Please try again later."
        case "REQUEST_DENIED":
            return "Search request denied. Please try again."
        case "INVALID_REQUEST":
            return "Invalid search request. Please check your input."
        default:
            return "Search service temporarily unavailable. Please try again."
        }
    }
}

// MARK: - Computed Properties

extension SearchViewModel {
    
    /// Whether we have any results to show
    var hasResults: Bool {
        !searchResults.isEmpty
    }
    
    /// Whether we should show "no results" message
    var shouldShowNoResults: Bool {
        hasSearched && !isLoading && searchResults.isEmpty && errorMessage == nil
    }
    
    /// Whether we should show error message
    var shouldShowError: Bool {
        errorMessage != nil
    }
    
    /// Current search state for UI
    var searchState: SearchState {
        if isLoading {
            return .loading
        } else if shouldShowError {
            return .error(errorMessage ?? "Unknown error")
        } else if shouldShowNoResults {
            return .noResults
        } else if hasResults {
            return .results(searchResults)
        } else {
            return .empty
        }
    }
}

// MARK: - Search State Enum

enum SearchState {
    case empty
    case loading
    case results([GooglePlace])
    case noResults
    case error(String)
} 