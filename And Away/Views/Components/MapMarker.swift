//
//  MapMarker.swift
//  And Away
//
//  A map marker component that displays a category icon with appropriate styling
//

import SwiftUI

struct MapMarker: View {
    // The color for the marker background (typically a category color)
    let backgroundColor: Color
    // Optional icon to display inside the marker
    let icon: Image?
    
    // Default initializer with category color
    init(backgroundColor: Color, icon: Image? = nil) {
        self.backgroundColor = backgroundColor
        self.icon = icon
    }
    
    // Convenience initializer for category-based markers
    init(category: MainCategory, icon: Image? = nil) {
        self.backgroundColor = category.color
        self.icon = icon
    }
    
    var body: some View {
        ZStack {
            if let icon = icon {
                icon
                    .font(.system(size: 12))
                    .foregroundColor(.white100)
            }
        }
        .padding(3)
        .frame(width: 22, height: 22, alignment: .center)
        .background(backgroundColor)
        .cornerRadius(11)
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 11)
                .inset(by: -1)
                .stroke(Color.white100, lineWidth: 2)
        )
    }
}

// MARK: - Preview
#Preview("Map Markers") {
    ScrollView {
        VStack(spacing: 15) {
            // Main categories
            Text("Main Categories")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ForEach(MainCategory.allCases, id: \.self) { category in
                HStack(spacing: 12) {
                    MapMarker(
                        category: category,
                        icon: getRepresentativeIcon(for: category)
                    )
                    Text(category.rawValue)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primary)
                    Spacer()
                }
            }
            
            Divider()
                .padding(.vertical, 10)
            
            // All subcategories
            Text("All Subcategories")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ForEach(Subcategory.allCases, id: \.self) { subcategory in
                HStack(spacing: 12) {
                    MapMarker(
                        category: subcategory.mainCategory,
                        icon: subcategory.icon
                    )
                    VStack(alignment: .leading, spacing: 2) {
                        Text(subcategory.rawValue)
                            .font(.system(size: 14))
                            .foregroundColor(.primary)
                        Text(subcategory.mainCategory.rawValue)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
            }
        }
        .padding()
    }
    .background(Color.backgroundPrimary)
}

// Helper function to get a representative icon for each main category
private func getRepresentativeIcon(for category: MainCategory) -> Image {
    // Get the first subcategory for each main category as a representative
    let representativeSubcategory: Subcategory
    
    switch category {
    case .travel:
        representativeSubcategory = .flights
    case .foodDrink:
        representativeSubcategory = .restaurant
    case .artFun:
        representativeSubcategory = .museum
    case .locations:
        representativeSubcategory = .location
    case .workStudy:
        representativeSubcategory = .library
    case .outdoor:
        representativeSubcategory = .park
    case .sports:
        representativeSubcategory = .fitness
    case .services:
        representativeSubcategory = .gasStation
    case .health:
        representativeSubcategory = .hospital
    case .shopping:
        representativeSubcategory = .shopping
    }
    
    return representativeSubcategory.icon
} 