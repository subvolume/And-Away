import Foundation

class GooglePlacesService {
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    // MARK: - Autocomplete Search
    func autocomplete(query: String) async throws -> [GooglePlace] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(encodedQuery)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw GooglePlacesError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(GoogleAutocompleteResponse.self, from: data)
        
        return response.predictions.map { prediction in
            GooglePlace(
                placeId: prediction.placeId,
                name: prediction.structuredFormatting.mainText,
                vicinity: prediction.structuredFormatting.secondaryText,
                types: prediction.types,
                location: nil,
                photos: nil,
                formattedPhoneNumber: nil,
                openingHours: nil
            )
        }
    }
    
    // MARK: - Text Search
    func textSearch(query: String) async throws -> [GooglePlace] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(encodedQuery)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw GooglePlacesError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(GooglePlacesSearchResponse.self, from: data)
        
        return response.results.map { result in
            GooglePlace(
                placeId: result.placeId,
                name: result.name,
                vicinity: result.vicinity,
                types: result.types,
                location: result.geometry.location,
                photos: result.photos,
                formattedPhoneNumber: nil,
                openingHours: nil
            )
        }
    }
}

// MARK: - Error Handling
enum GooglePlacesError: Error {
    case invalidURL
    case noData
    case decodingError
} 