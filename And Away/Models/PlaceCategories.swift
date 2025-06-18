import SwiftUI

// MARK: - Main Category Groups (with colors)

enum MainCategory: String, CaseIterable, Identifiable {
    case travel = "travel"
    case foodAndDrink = "food_and_drink"
    case artAndFun = "art_and_fun"
    case locations = "locations"
    case workAndStudy = "work_and_study"
    case outdoor = "outdoor"
    case sports = "sports"
    case services = "services"
    case health = "health"
    case shopping = "shopping"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .travel: return "Travel"
        case .foodAndDrink: return "Food & Drink"
        case .artAndFun: return "Art & Fun"
        case .locations: return "Locations"
        case .workAndStudy: return "Work & Study"
        case .outdoor: return "Outdoor"
        case .sports: return "Sports"
        case .services: return "Services"
        case .health: return "Health"
        case .shopping: return "Shopping"
        }
    }
    

    
    var color: Color {
        switch self {
        case .travel: return .blue
        case .foodAndDrink: return .orange
        case .artAndFun: return .purple
        case .locations: return .red
        case .workAndStudy: return .indigo
        case .outdoor: return .green
        case .sports: return .mint
        case .services: return .gray
        case .health: return .pink
        case .shopping: return .teal
        }
    }
    
    var lightColor: Color {
        return color.opacity(0.2)
    }
}

// MARK: - Subcategories (with icons and Google API mappings)

enum PlaceSubcategory: String, CaseIterable, Identifiable {
    // Travel
    case flights = "flights"
    case lodgings = "lodgings"
    case routes = "routes"
    case carRental = "car_rental"
    
    // Food & Drink
    case bakery = "bakery"
    case barAndParty = "bar_and_party"
    case brewery = "brewery"
    case cafe = "cafe"
    case restaurant = "restaurant"
    case winery = "winery"
    
    // Art & Fun
    case amusementPark = "amusement_park"
    case concert = "concert"
    case event = "event"
    case kids = "kids"
    case movieTheater = "movie_theater"
    case museum = "museum"
    case nightlife = "nightlife"
    case theater = "theater"
    case tour = "tour"
    
    // Locations
    case location = "location"
    
    // Work & Study
    case library = "library"
    case meeting = "meeting"
    case school = "school"
    case university = "university"
    
    // Outdoor
    case beach = "beach"
    case campground = "campground"
    case nationalPark = "national_park"
    case park = "park"
    case relax = "relax"
    
    // Sports
    case fitness = "fitness"
    case stadium = "stadium"
    
    // Services
    case atm = "atm"
    case bank = "bank"
    case evCharger = "ev_charger"
    case fireStation = "fire_station"
    case gasStation = "gas_station"
    case laundry = "laundry"
    case marina = "marina"
    case parking = "parking"
    case police = "police"
    case postOffice = "post_office"
    case publicTransport = "public_transport"
    
    // Health
    case hospital = "hospital"
    case pharmacy = "pharmacy"
    
    // Shopping
    case foodMarket = "food_market"
    case shopping = "shopping"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        // Travel
        case .flights: return "Flights"
        case .lodgings: return "Lodgings"
        case .routes: return "Routes"
        case .carRental: return "Car Rental"
        
        // Food & Drink
        case .bakery: return "Bakery"
        case .barAndParty: return "Bar & Party"
        case .brewery: return "Brewery"
        case .cafe: return "Cafe"
        case .restaurant: return "Restaurant"
        case .winery: return "Winery"
        
        // Art & Fun
        case .amusementPark: return "Amusement Park"
        case .concert: return "Concert"
        case .event: return "Event"
        case .kids: return "Kids"
        case .movieTheater: return "Movie Theater"
        case .museum: return "Museum"
        case .nightlife: return "Nightlife"
        case .theater: return "Theater"
        case .tour: return "Tour"
        
        // Locations
        case .location: return "Location"
        
        // Work & Study
        case .library: return "Library"
        case .meeting: return "Meeting"
        case .school: return "School"
        case .university: return "University"
        
        // Outdoor
        case .beach: return "Beach"
        case .campground: return "Campground"
        case .nationalPark: return "National Park"
        case .park: return "Park"
        case .relax: return "Relax"
        
        // Sports
        case .fitness: return "Fitness"
        case .stadium: return "Stadium"
        
        // Services
        case .atm: return "ATM"
        case .bank: return "Bank"
        case .evCharger: return "EV Charger"
        case .fireStation: return "Fire Station"
        case .gasStation: return "Gas Station"
        case .laundry: return "Laundry"
        case .marina: return "Marina"
        case .parking: return "Parking"
        case .police: return "Police"
        case .postOffice: return "Post Office"
        case .publicTransport: return "Public Transport"
        
        // Health
        case .hospital: return "Hospital"
        case .pharmacy: return "Pharmacy"
        
        // Shopping
        case .foodMarket: return "Food Market"
        case .shopping: return "Shopping"
        }
    }
    
    var icon: String {
        switch self {
        // Travel
        case .flights: return "airplane"
        case .lodgings: return "bed.double.fill"
        case .routes: return "map.fill"
        case .carRental: return "car.fill"
        
        // Food & Drink
        case .bakery: return "birthday.cake.fill"
        case .barAndParty: return "wineglass.fill"
        case .brewery: return "mug.fill"
        case .cafe: return "cup.and.saucer.fill"
        case .restaurant: return "fork.knife"
        case .winery: return "wineglass.fill"
        
        // Art & Fun
        case .amusementPark: return "face.smiling.inverse"
        case .concert: return "music.note"
        case .event: return "calendar.badge.exclamationmark"
        case .kids: return "figure.and.child.holdinghands"
        case .movieTheater: return "popcorn.fill"
        case .museum: return "building.columns.fill"
        case .nightlife: return "moon.stars.fill"
        case .theater: return "theatermasks.fill"
        case .tour: return "binoculars.fill"
        
        // Locations
        case .location: return "mappin"
        
        // Work & Study
        case .library: return "books.vertical.fill"
        case .meeting: return "person.3.fill"
        case .school: return "graduationcap.fill"
        case .university: return "building.2.fill"
        
        // Outdoor
        case .beach: return "beach.umbrella.fill"
        case .campground: return "tent.fill"
        case .nationalPark: return "mountain.2.fill"
        case .park: return "tree.fill"
        case .relax: return "leaf.fill"
        
        // Sports
        case .fitness: return "dumbbell.fill"
        case .stadium: return "sportscourt.fill"
        
        // Services
        case .atm: return "banknote.fill"
        case .bank: return "dollarsign.bank.building.fill"
        case .evCharger: return "ev.charger.fill"
        case .fireStation: return "flame.fill"
        case .gasStation: return "fuelpump.fill"
        case .laundry: return "washer.fill"
        case .marina: return "sailboat.fill"
        case .parking: return "parkingsign"
        case .police: return "shield.checkered"
        case .postOffice: return "envelope.fill"
        case .publicTransport: return "bus.fill"
        
        // Health
        case .hospital: return "cross.case.fill"
        case .pharmacy: return "pills.fill"
        
        // Shopping
        case .foodMarket: return "basket.fill"
        case .shopping: return "bag.fill"
        }
    }
    
    var mainCategory: MainCategory {
        switch self {
        // Travel
        case .flights, .lodgings, .routes, .carRental:
            return .travel
        
        // Food & Drink
        case .bakery, .barAndParty, .brewery, .cafe, .restaurant, .winery:
            return .foodAndDrink
        
        // Art & Fun
        case .amusementPark, .concert, .event, .kids, .movieTheater, .museum, .nightlife, .theater, .tour:
            return .artAndFun
        
        // Locations
        case .location:
            return .locations
        
        // Work & Study
        case .library, .meeting, .school, .university:
            return .workAndStudy
        
        // Outdoor
        case .beach, .campground, .nationalPark, .park, .relax:
            return .outdoor
        
        // Sports
        case .fitness, .stadium:
            return .sports
        
        // Services
        case .atm, .bank, .evCharger, .fireStation, .gasStation, .laundry, .marina, .parking, .police, .postOffice, .publicTransport:
            return .services
        
        // Health
        case .hospital, .pharmacy:
            return .health
        
        // Shopping
        case .foodMarket, .shopping:
            return .shopping
        }
    }
    
    var googlePlaceTypes: [String] {
        switch self {
        // Travel
        case .flights:
            return ["airport", "international_airport"]
        case .lodgings:
            return ["lodging", "hotel", "motel", "bed_and_breakfast", "hostel", "inn", "resort_hotel", "extended_stay_hotel", "campground", "rv_park", "guest_house"]
        case .routes:
            return ["route", "highway", "road"]
        case .carRental:
            return ["car_rental"]
        
        // Food & Drink
        case .bakery:
            return ["bakery", "donut_shop", "bagel_shop"]
        case .barAndParty:
            return ["bar", "pub", "wine_bar", "cocktail_lounge", "sports_bar"]
        case .brewery:
            return ["brewery", "beer_garden"]
        case .cafe:
            return ["cafe", "coffee_shop", "tea_house"]
        case .restaurant:
            return ["restaurant", "meal_delivery", "meal_takeaway", "fast_food_restaurant", "fine_dining_restaurant", "pizza_restaurant", "chinese_restaurant", "italian_restaurant", "mexican_restaurant", "indian_restaurant", "japanese_restaurant", "thai_restaurant", "vietnamese_restaurant", "korean_restaurant", "seafood_restaurant", "steak_house", "sushi_restaurant", "french_restaurant", "greek_restaurant", "spanish_restaurant", "mediterranean_restaurant", "middle_eastern_restaurant", "american_restaurant", "barbecue_restaurant", "hamburger_restaurant", "sandwich_shop", "deli", "food_court", "buffet_restaurant", "ramen_restaurant", "vegan_restaurant", "vegetarian_restaurant"]
        case .winery:
            return ["winery", "vineyard"]
        
        // Art & Fun
        case .amusementPark:
            return ["amusement_park", "water_park", "theme_park"]
        case .concert:
            return ["concert_hall", "music_venue", "amphitheater"]
        case .event:
            return ["event_venue", "convention_center", "wedding_venue", "banquet_hall"]
        case .kids:
            return ["amusement_park", "zoo", "aquarium", "children_museum", "playground"]
        case .movieTheater:
            return ["movie_theater", "cinema", "drive_in_theater"]
        case .museum:
            return ["museum", "art_gallery", "science_museum", "history_museum"]
        case .nightlife:
            return ["night_club", "dance_club", "karaoke", "comedy_club"]
        case .theater:
            return ["performing_arts_theater", "opera_house", "theater"]
        case .tour:
            return ["tourist_attraction", "tour_operator", "travel_agency"]
        
        // Locations
        case .location:
            return ["establishment", "point_of_interest", "premise"]
        
        // Work & Study
        case .library:
            return ["library"]
        case .meeting:
            return ["conference_room", "meeting_room", "business_center"]
        case .school:
            return ["school", "primary_school", "secondary_school"]
        case .university:
            return ["university", "college"]
        
        // Outdoor
        case .beach:
            return ["beach", "waterfront"]
        case .campground:
            return ["campground", "rv_park", "camping_cabin"]
        case .nationalPark:
            return ["national_park", "state_park"]
        case .park:
            return ["park", "botanical_garden", "garden"]
        case .relax:
            return ["spa", "wellness_center", "massage", "sauna"]
        
        // Sports
        case .fitness:
            return ["gym", "fitness_center", "yoga_studio", "pilates_studio"]
        case .stadium:
            return ["stadium", "sports_complex", "arena"]
        
        // Services
        case .atm:
            return ["atm"]
        case .bank:
            return ["bank", "credit_union"]
        case .evCharger:
            return ["electric_vehicle_charging_station"]
        case .fireStation:
            return ["fire_station"]
        case .gasStation:
            return ["gas_station", "fuel"]
        case .laundry:
            return ["laundry", "dry_cleaning"]
        case .marina:
            return ["marina", "harbor"]
        case .parking:
            return ["parking", "parking_garage"]
        case .police:
            return ["police"]
        case .postOffice:
            return ["post_office"]
        case .publicTransport:
            return ["bus_station", "train_station", "subway_station", "light_rail_station", "transit_station", "bus_stop"]
        
        // Health
        case .hospital:
            return ["hospital", "medical_center", "clinic", "urgent_care"]
        case .pharmacy:
            return ["pharmacy", "drugstore"]
        
        // Shopping
        case .foodMarket:
            return ["supermarket", "grocery_store", "market", "food_market"]
        case .shopping:
            return ["shopping_mall", "store", "department_store", "clothing_store", "electronics_store", "book_store", "furniture_store", "home_goods_store", "jewelry_store", "shoe_store", "sporting_goods_store", "pet_store", "gift_shop"]
        }
    }
}

// MARK: - Category Management

extension MainCategory {
    var subcategories: [PlaceSubcategory] {
        return PlaceSubcategory.allCases.filter { $0.mainCategory == self }
    }
}

extension PlaceSubcategory {
    var color: Color {
        return mainCategory.color
    }
    
    var lightColor: Color {
        return mainCategory.lightColor
    }
}

// MARK: - Search and Detection

extension PlaceSubcategory {
    static func detectFromQuery(_ query: String) -> PlaceSubcategory? {
        let lowercaseQuery = query.lowercased()
        
        // Direct name matching first
        for subcategory in PlaceSubcategory.allCases {
            if lowercaseQuery.contains(subcategory.rawValue.replacingOccurrences(of: "_", with: " ")) ||
               lowercaseQuery.contains(subcategory.displayName.lowercased()) {
                return subcategory
            }
        }
        
        return nil
    }
}

// MARK: - GooglePlace Extensions

extension GooglePlace {
    var primarySubcategory: PlaceSubcategory? {
        let placeTypes = Set(self.types)
        
        for subcategory in PlaceSubcategory.allCases {
            let subcategoryTypes = Set(subcategory.googlePlaceTypes)
            if !subcategoryTypes.isDisjoint(with: placeTypes) {
                return subcategory
            }
        }
        
        return nil
    }
    
    var allMatchingSubcategories: [PlaceSubcategory] {
        let placeTypes = Set(self.types)
        
        return PlaceSubcategory.allCases.filter { subcategory in
            let subcategoryTypes = Set(subcategory.googlePlaceTypes)
            return !subcategoryTypes.isDisjoint(with: placeTypes)
        }
    }
    
    func matches(subcategory: PlaceSubcategory) -> Bool {
        let placeTypes = Set(self.types)
        let subcategoryTypes = Set(subcategory.googlePlaceTypes)
        return !subcategoryTypes.isDisjoint(with: placeTypes)
    }
}

// MARK: - SwiftUI Components

struct MainCategoryView: View {
    let category: MainCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(category.displayName)
                    .font(.headline)
                    .fontWeight(.medium)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? category.color : category.lightColor)
            )
            .foregroundColor(isSelected ? .white : category.color)
        }
    }
}

struct SubcategoryView: View {
    let subcategory: PlaceSubcategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: subcategory.icon)
                    .font(.title3)
                    .foregroundColor(isSelected ? .white : subcategory.color)
                    .frame(width: 24)
                
                Text(subcategory.displayName)
                    .font(.body)
                    .fontWeight(.medium)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? subcategory.color : subcategory.lightColor)
            )
            .foregroundColor(isSelected ? .white : subcategory.color)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        ScrollView {
            VStack(spacing: 0) {
                // Show ALL main categories with ALL their subcategories for review
                ForEach(MainCategory.allCases) { mainCategory in
                    VStack(spacing: 0) {
                        // Main category header using SectionHeaderView
                        SectionHeaderView(
                            title: mainCategory.displayName,
                            showViewAllButton: false,
                            onViewAllTapped: {
                                print("View all \(mainCategory.displayName) categories")
                            }
                        )
                        
                        // ALL subcategories using ListItem with proper ArtworkView integration
                        ForEach(mainCategory.subcategories) { subcategory in
                            ListItem(
                                artwork: .circleIcon(
                                    color: subcategory.color,
                                    icon: Image(systemName: subcategory.icon)
                                ),
                                title: subcategory.displayName,
                                subtitle: "\(subcategory.googlePlaceTypes.count) place types",
                                thirdText: subcategory.googlePlaceTypes.first ?? "No types",
                                onTap: {
                                    print("Selected \(subcategory.displayName)")
                                }
                            )
                        }
                    }
                }
            }
        }
        .navigationTitle("All Place Categories")
    }
} 
