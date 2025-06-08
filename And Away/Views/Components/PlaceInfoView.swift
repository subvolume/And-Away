import SwiftUI

struct PlaceInfoView: View {
    let place: PlaceDetails
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // Address
            if let address = place.formattedAddress {
                InfoRow(
                    icon: "location",
                    title: "Address",
                    content: address
                )
            }
            
            // Rating and Reviews
            HStack {
                if let rating = place.rating {
                    InfoRow(
                        icon: "star.fill",
                        title: "Rating",
                        content: "\(String(format: "%.1f", rating))/5"
                    )
                }
                
                if let reviewCount = place.userRatingsTotal {
                    InfoRow(
                        icon: "person.2",
                        title: "Reviews",
                        content: "\(reviewCount) reviews"
                    )
                }
            }
            
            // Phone Number
            if let phone = place.formattedPhoneNumber {
                InfoRow(
                    icon: "phone",
                    title: "Phone",
                    content: phone
                )
            }
            
            // Website
            if let website = place.website {
                InfoRow(
                    icon: "globe",
                    title: "Website",
                    content: website
                )
            }
            
            // Opening Hours
            if let openingHours = place.openingHours {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.secondary)
                        Text("Hours")
                            .font(.headline)
                    }
                    
                    if let isOpen = openingHours.openNow {
                        Text(isOpen ? "Open now" : "Closed")
                            .font(.body)
                            .foregroundColor(isOpen ? .green : .red)
                    }
                    
                    if let weekdayText = openingHours.weekdayText {
                        ForEach(weekdayText, id: \.self) { dayHours in
                            Text(dayHours)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            
            // Price Level
            if let priceLevel = place.priceLevel {
                InfoRow(
                    icon: "dollarsign.circle",
                    title: "Price",
                    content: priceSymbols(for: priceLevel)
                )
            }
            
            // Place Types
            if !place.types.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "tag")
                            .foregroundColor(.secondary)
                        Text("Categories")
                            .font(.headline)
                    }
                    
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 100))
                    ], spacing: 8) {
                        ForEach(place.types.prefix(6), id: \.self) { type in
                            Text(formatPlaceType(type))
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(12)
                        }
                    }
                }
            }
        }
        .padding()
    }
    
    // MARK: - Helper Functions
    private func priceSymbols(for level: Int) -> String {
        switch level {
        case 0: return "Free"
        case 1: return "$"
        case 2: return "$$"
        case 3: return "$$$"
        case 4: return "$$$$"
        default: return "Unknown"
        }
    }
    
    private func formatPlaceType(_ type: String) -> String {
        return type.replacingOccurrences(of: "_", with: " ").capitalized
    }
}

// MARK: - Info Row Component
struct InfoRow: View {
    let icon: String
    let title: String
    let content: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.secondary)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(content)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

// MARK: - Preview
#Preview {
    PlaceInfoView(place: PlaceDetails(
        placeId: "test",
        name: "Test Restaurant",
        formattedAddress: "123 Main St, New York, NY",
        formattedPhoneNumber: "(555) 123-4567",
        internationalPhoneNumber: "+1 555-123-4567",
        website: "https://example.com",
        rating: 4.5,
        userRatingsTotal: 120,
        priceLevel: 2,
        photos: nil,
        reviews: nil,
        openingHours: nil,
        geometry: PlaceGeometry(location: PlaceLocation(lat: 0, lng: 0), viewport: nil),
        types: ["restaurant", "food", "establishment"],
        businessStatus: nil,
        utcOffset: nil
    ))
    .padding()
} 