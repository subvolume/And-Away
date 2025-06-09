import Foundation
import CoreLocation
import SwiftUI

// MARK: - Bookmark Manager
@MainActor
class BookmarkManager: ObservableObject {
    
    // MARK: - Published Properties
    @Published var savedPlaces: [SavedPlace] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Singleton
    static let shared = BookmarkManager()
    
    // MARK: - Private Properties
    private let userDefaults = UserDefaults.standard
    private let savedPlacesKey = "SavedPlaces"
    
    // MARK: - Initialization
    private init() {
        loadSavedPlaces()
    }
    
    // MARK: - Core Bookmark Functions
    
    /// Bookmark a place from search results
    func bookmark(place: PlaceSearchResult, notes: String = "", context: BookmarkContext = .manual) {
        // Check if already bookmarked
        guard !isBookmarked(placeId: place.placeId) else {
            print("Place already bookmarked: \(place.name)")
            return
        }
        
        let savedPlace = SavedPlace(from: place, notes: notes, context: context)
        savedPlaces.append(savedPlace)
        saveToPersistence()
        
        print("✅ Bookmarked: \(place.name)")
    }
    
    /// Bookmark a place from detailed results
    func bookmark(placeDetails: PlaceDetails, notes: String = "", context: BookmarkContext = .manual) {
        // Check if already bookmarked
        guard !isBookmarked(placeId: placeDetails.placeId) else {
            print("Place already bookmarked: \(placeDetails.name)")
            return
        }
        
        let savedPlace = SavedPlace(from: placeDetails, notes: notes, context: context)
        savedPlaces.append(savedPlace)
        saveToPersistence()
        
        print("✅ Bookmarked: \(placeDetails.name)")
    }
    
    /// Remove bookmark
    func unbookmark(placeId: String) {
        if let index = savedPlaces.firstIndex(where: { $0.placeId == placeId }) {
            let placeName = savedPlaces[index].name
            savedPlaces.remove(at: index)
            saveToPersistence()
            print("❌ Unbookmarked: \(placeName)")
        }
    }
    
    /// Check if a place is bookmarked
    func isBookmarked(placeId: String) -> Bool {
        return savedPlaces.contains { $0.placeId == placeId }
    }
    
    /// Update an existing saved place
    func updatePlace(_ updatedPlace: SavedPlace) {
        if let index = savedPlaces.firstIndex(where: { $0.placeId == updatedPlace.placeId }) {
            savedPlaces[index] = updatedPlace
            saveToPersistence()
            print("📝 Updated place: \(updatedPlace.name)")
        }
    }
    
    /// Update just the notes for a place
    func updateNotes(placeId: String, notes: String) {
        if let index = savedPlaces.firstIndex(where: { $0.placeId == placeId }) {
            var updatedPlace = savedPlaces[index]
            var mutablePlace = updatedPlace
            mutablePlace.notes = notes
            savedPlaces[index] = mutablePlace
            saveToPersistence()
            print("📝 Updated notes for: \(updatedPlace.name)")
        }
    }
    
    /// Update visit status for a place
    func updateVisitStatus(placeId: String, status: VisitStatus) {
        if let index = savedPlaces.firstIndex(where: { $0.placeId == placeId }) {
            var updatedPlace = savedPlaces[index]
            var mutablePlace = updatedPlace
            mutablePlace.visitStatus = status
            savedPlaces[index] = mutablePlace
            saveToPersistence()
            print("🎯 Updated visit status for: \(updatedPlace.name) to \(status.displayName)")
        }
    }
    
    /// Update user rating for a place
    func updateUserRating(placeId: String, rating: Int?) {
        if let index = savedPlaces.firstIndex(where: { $0.placeId == placeId }) {
            var updatedPlace = savedPlaces[index]
            var mutablePlace = updatedPlace
            mutablePlace.userRating = rating
            savedPlaces[index] = mutablePlace
            saveToPersistence()
            print("⭐ Updated rating for: \(updatedPlace.name) to \(rating ?? 0)")
        }
    }
    
    // MARK: - Search and Filter Functions (Prepared for UI)
    
    /// Get places by category
    func getPlacesByCategory(_ category: PlaceCategory) -> [SavedPlace] {
        return savedPlaces.filtered(by: category)
    }
    
    /// Get places by visit status
    func getPlacesByStatus(_ status: VisitStatus) -> [SavedPlace] {
        return savedPlaces.filtered(by: status)
    }
    
    /// Search places by query
    func searchPlaces(query: String) -> [SavedPlace] {
        return savedPlaces.searched(query: query)
    }
    
    /// Get places sorted by distance from user location
    func getPlacesSortedByDistance(from userLocation: CLLocation) -> [SavedPlace] {
        return savedPlaces.sorted(by: userLocation)
    }
    
    /// Get places within a certain radius
    func getPlacesNearby(to location: CLLocation, radius: Double = 10000) -> [SavedPlace] {
        return savedPlaces.filter { place in
            place.distanceFrom(location) <= radius
        }
    }
    
    /// Get recently bookmarked places
    func getRecentlyBookmarked(limit: Int = 10) -> [SavedPlace] {
        return savedPlaces.sortedByDateBookmarked().prefix(limit).map { $0 }
    }
    
    /// Get places that haven't been visited yet
    func getUnvisitedPlaces() -> [SavedPlace] {
        return savedPlaces.filter { $0.visitStatus == .planned }
    }
    
    /// Get favorite places
    func getFavoritePlaces() -> [SavedPlace] {
        return savedPlaces.filter { $0.visitStatus == .favorite }
    }
    
    // MARK: - Statistics (For future dashboard)
    
    var totalBookmarkedPlaces: Int {
        return savedPlaces.count
    }
    
    var placesVisited: Int {
        return savedPlaces.filter { $0.visitStatus == .visited || $0.visitStatus == .favorite }.count
    }
    
    var favoritePlaces: Int {
        return savedPlaces.filter { $0.visitStatus == .favorite }.count
    }
    
    var categoryCounts: [PlaceCategory: Int] {
        var counts: [PlaceCategory: Int] = [:]
        for place in savedPlaces {
            counts[place.category, default: 0] += 1
        }
        return counts
    }
    
    // MARK: - Persistence (Local Storage)
    
    private func saveToPersistence() {
        do {
            let data = try JSONEncoder().encode(savedPlaces)
            userDefaults.set(data, forKey: savedPlacesKey)
            print("💾 Saved \(savedPlaces.count) places to local storage")
            
            // TODO: Add cloud sync here when ready
            // saveToCloud()
            
        } catch {
            errorMessage = "Failed to save bookmarks: \(error.localizedDescription)"
            print("❌ Failed to save places: \(error)")
        }
    }
    
    private func loadSavedPlaces() {
        isLoading = true
        
        guard let data = userDefaults.data(forKey: savedPlacesKey) else {
            print("📂 No saved places found - starting fresh")
            isLoading = false
            return
        }
        
        do {
            savedPlaces = try JSONDecoder().decode([SavedPlace].self, from: data)
            print("📂 Loaded \(savedPlaces.count) places from local storage")
            
            // TODO: Add cloud sync check here when ready
            // syncWithCloud()
            
        } catch {
            errorMessage = "Failed to load bookmarks: \(error.localizedDescription)"
            print("❌ Failed to load places: \(error)")
            savedPlaces = []
        }
        
        isLoading = false
    }
    
    // MARK: - Cloud Sync (Prepared for future)
    
    /// Prepare for cloud sync - will implement with CloudKit later
    private func saveToCloud() {
        // TODO: Implement CloudKit sync
        print("☁️ Cloud sync - coming soon!")
    }
    
    private func loadFromCloud() async {
        // TODO: Implement CloudKit loading
        print("☁️ Loading from cloud - coming soon!")
    }
    
    private func syncWithCloud() {
        // TODO: Implement full cloud sync
        print("☁️ Full cloud sync - coming soon!")
    }
    
    // MARK: - AI Integration Preparation
    
    /// Get context data for AI recommendations
    func getRecommendationContext() -> [String: Any] {
        return [
            "totalPlaces": savedPlaces.count,
            "categories": categoryCounts.mapValues { $0 },
            "recentPlaces": getRecentlyBookmarked(limit: 5).map { $0.name },
            "favoritePlaces": getFavoritePlaces().map { $0.name },
            "unvisitedCount": getUnvisitedPlaces().count
        ]
    }
    
    /// Mark a place as viewed (for recommendation algorithms)
    func markAsViewed(placeId: String) {
        if let index = savedPlaces.firstIndex(where: { $0.placeId == placeId }) {
            var updatedPlace = savedPlaces[index]
            var mutablePlace = updatedPlace
            mutablePlace.lastViewedDate = Date()
            savedPlaces[index] = mutablePlace
            saveToPersistence()
        }
    }
    
    // MARK: - Bulk Operations
    
    /// Clear all bookmarks (with confirmation)
    func clearAllBookmarks() {
        savedPlaces.removeAll()
        saveToPersistence()
        print("🗑️ Cleared all bookmarks")
    }
    
    /// Export bookmarks (for backup/sharing)
    func exportBookmarks() -> Data? {
        do {
            return try JSONEncoder().encode(savedPlaces)
        } catch {
            print("❌ Failed to export bookmarks: \(error)")
            return nil
        }
    }
    
    /// Import bookmarks (from backup/sharing)
    func importBookmarks(from data: Data, replaceExisting: Bool = false) {
        do {
            let importedPlaces = try JSONDecoder().decode([SavedPlace].self, from: data)
            
            if replaceExisting {
                savedPlaces = importedPlaces
            } else {
                // Merge, avoiding duplicates
                for importedPlace in importedPlaces {
                    if !isBookmarked(placeId: importedPlace.placeId) {
                        savedPlaces.append(importedPlace)
                    }
                }
            }
            
            saveToPersistence()
            print("📥 Imported \(importedPlaces.count) places")
            
        } catch {
            errorMessage = "Failed to import bookmarks: \(error.localizedDescription)"
            print("❌ Failed to import bookmarks: \(error)")
        }
    }
} 