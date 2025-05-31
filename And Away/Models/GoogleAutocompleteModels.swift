import Foundation

// MARK: - Google Places Autocomplete Response
struct GoogleAutocompleteResponse: Codable {
    let predictions: [AutocompletePrediction]
    let status: String
}

// MARK: - Individual Autocomplete Suggestion
struct AutocompletePrediction: Codable, Identifiable {
    let id = UUID()
    let placeId: String
    let description: String
    let structuredFormatting: StructuredFormatting
    let types: [String]
    
    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case description
        case structuredFormatting = "structured_formatting"
        case types
    }
}

// MARK: - Formatted Text (Main text + Secondary text)
struct StructuredFormatting: Codable {
    let mainText: String
    let secondaryText: String?
    
    enum CodingKeys: String, CodingKey {
        case mainText = "main_text"
        case secondaryText = "secondary_text"
    }
} 