import SwiftUI

// MARK: - Main Category
enum MainCategory: String, CaseIterable {
    case travel = "Travel"
    case foodDrink = "Food & Drink"
    case artFun = "Art & Fun"
    case locations = "Locations"
    case workStudy = "Work & Study"
    case outdoor = "Outdoor"
    case sports = "Sports"
    case services = "Services"
    case health = "Health"
    case shopping = "Shopping"
    
    var color: Color {
        switch self {
        case .travel: return .sky100
        case .foodDrink: return .orange100
        case .artFun: return .purple100
        case .locations: return .grey100
        case .workStudy: return .blue100
        case .outdoor: return .green100
        case .sports: return .red100
        case .services: return .teal100
        case .health: return .aqua100
        case .shopping: return .yellow100
        }
    }
    
    var lightColor: Color {
        switch self {
        case .travel: return .sky15
        case .foodDrink: return .orange15
        case .artFun: return .purple15
        case .locations: return .grey15
        case .workStudy: return .blue15
        case .outdoor: return .green15
        case .sports: return .red15
        case .services: return .teal15
        case .health: return .aqua15
        case .shopping: return .yellow15
        }
    }
}

// MARK: - Subcategory
enum Subcategory: String, CaseIterable {
    // Travel
    case flights = "Flights"
    case lodgings = "Lodgings"
    case routes = "Routes"
    case carRental = "Car Rental"
    
    // Food & Drink
    case bakery = "Bakery"
    case barParty = "Bar & Party"
    case brewery = "Brewery"
    case cafe = "Cafe"
    case restaurant = "Restaurant"
    case winery = "Winery"
    
    // Art & Fun
    case amusementPark = "Amusement Park"
    case concert = "Concert"
    case event = "Event"
    case kids = "Kids"
    case movieTheater = "Movie Theater"
    case museum = "Museum"
    case nightlife = "Nightlife"
    case theater = "Theater"
    case tour = "Tour"
    
    // Locations
    case location = "Location"
    
    // Work & Study
    case library = "Library"
    case meeting = "Meeting"
    case school = "School"
    case university = "University"
    
    // Outdoor
    case beach = "Beach"
    case campground = "Campground"
    case nationalPark = "National Park"
    case park = "Park"
    case relax = "Relax"
    
    // Sports
    case fitness = "Fitness"
    case stadium = "Stadium"
    
    // Services
    case atm = "ATM"
    case bank = "Bank"
    case evCharger = "EV Charger"
    case fireStation = "Fire Station"
    case gasStation = "Gas Station"
    case laundry = "Laundry"
    case marina = "Marina"
    case parking = "Parking"
    case police = "Police"
    case postOffice = "Post Office"
    case publicTransport = "Public Transport"
    
    // Health
    case hospital = "Hospital"
    case pharmacy = "Pharmacy"
    
    // Shopping
    case foodMarket = "Food Market"
    case shopping = "Shopping"
    
    var mainCategory: MainCategory {
        switch self {
        case .flights, .lodgings, .routes, .carRental:
            return .travel
        case .bakery, .barParty, .brewery, .cafe, .restaurant, .winery:
            return .foodDrink
        case .amusementPark, .concert, .event, .kids, .movieTheater, .museum, .nightlife, .theater, .tour:
            return .artFun
        case .location:
            return .locations
        case .library, .meeting, .school, .university:
            return .workStudy
        case .beach, .campground, .nationalPark, .park, .relax:
            return .outdoor
        case .fitness, .stadium:
            return .sports
        case .atm, .bank, .evCharger, .fireStation, .gasStation, .laundry, .marina, .parking, .police, .postOffice, .publicTransport:
            return .services
        case .hospital, .pharmacy:
            return .health
        case .foodMarket, .shopping:
            return .shopping
        }
    }
    
    var icon: Image {
        Image(systemName: iconName)
    }
    
    var iconName: String {
        switch self {
        // Travel
        case .flights: return "airplane"
        case .lodgings: return "bed.double.fill"
        case .routes: return "map.fill"
        case .carRental: return "car.fill"
        
        // Food & Drink
        case .bakery: return "birthday.cake.fill"
        case .barParty: return "wineglass.fill"
        case .brewery: return "mug.fill"
        case .cafe: return "cup.and.saucer.fill"
        case .restaurant: return "fork.knife"
        case .winery: return "wineglass.fill"
        
        // Art & Fun
        case .amusementPark: return "star.fill"
        case .concert: return "music.note"
        case .event: return "calendar"
        case .kids: return "figure.and.child.holdinghands"
        case .movieTheater: return "film.fill"
        case .museum: return "building.columns.fill"
        case .nightlife: return "moon.fill"
        case .theater: return "theatermasks.fill"
        case .tour: return "binoculars.fill"
        
        // Locations
        case .location: return "mappin.circle.fill"
        
        // Work & Study
        case .library: return "books.vertical.fill"
        case .meeting: return "person.3.fill"
        case .school: return "graduationcap.fill"
        case .university: return "building.2.fill"
        
        // Outdoor
        case .beach: return "beach.umbrella.fill"
        case .campground: return "tent.fill"
        case .nationalPark: return "tree.fill"
        case .park: return "leaf.fill"
        case .relax: return "chair.lounge.fill"
        
        // Sports
        case .fitness: return "figure.run"
        case .stadium: return "sportscourt.fill"
        
        // Services
        case .atm: return "creditcard.fill"
        case .bank: return "building.columns.fill"
        case .evCharger: return "bolt.car.fill"
        case .fireStation: return "flame.fill"
        case .gasStation: return "fuelpump.fill"
        case .laundry: return "washer.fill"
        case .marina: return "sailboat.fill"
        case .parking: return "parkingsign.circle.fill"
        case .police: return "shield.fill"
        case .postOffice: return "envelope.fill"
        case .publicTransport: return "bus.fill"
        
        // Health
        case .hospital: return "cross.circle.fill"
        case .pharmacy: return "pills.fill"
        
        // Shopping
        case .foodMarket: return "cart.fill"
        case .shopping: return "bag.fill"
        }
    }
}

// MARK: - Category Style
struct CategoryStyle {
    
    // MARK: - Google Places Type Mapping
    private static let googleTypeMappings: [String: Subcategory] = [
        // Travel
        "airport": .flights,
        "lodging": .lodgings,
        "hotel": .lodgings,
        "motel": .lodgings,
        "car_rental": .carRental,
        "travel_agency": .routes,
        
        // Food & Drink
        "bakery": .bakery,
        "bar": .barParty,
        "night_club": .barParty,
        "brewery": .brewery,
        "cafe": .cafe,
        "coffee_shop": .cafe,
        "restaurant": .restaurant,
        "food": .restaurant,
        "meal_delivery": .restaurant,
        "meal_takeaway": .restaurant,
        "winery": .winery,
        
        // Art & Fun
        "amusement_park": .amusementPark,
        "theme_park": .amusementPark,
        "concert_hall": .concert,
        "event_venue": .event,
        "movie_theater": .movieTheater,
        "museum": .museum,
        "art_gallery": .museum,
        "theater": .theater,
        "tourist_attraction": .tour,
        "zoo": .kids,
        "aquarium": .kids,
        
        // Work & Study
        "library": .library,
        "school": .school,
        "primary_school": .school,
        "secondary_school": .school,
        "university": .university,
        "conference_center": .meeting,
        
        // Outdoor
        "beach": .beach,
        "campground": .campground,
        "camping": .campground,
        "national_park": .nationalPark,
        "park": .park,
        "spa": .relax,
        
        // Sports
        "gym": .fitness,
        "fitness_center": .fitness,
        "stadium": .stadium,
        "sports_complex": .stadium,
        
        // Services
        "atm": .atm,
        "bank": .bank,
        "electric_vehicle_charging_station": .evCharger,
        "fire_station": .fireStation,
        "gas_station": .gasStation,
        "laundry": .laundry,
        "marina": .marina,
        "parking": .parking,
        "police": .police,
        "post_office": .postOffice,
        "bus_station": .publicTransport,
        "train_station": .publicTransport,
        "subway_station": .publicTransport,
        "transit_station": .publicTransport,
        
        // Health
        "hospital": .hospital,
        "doctor": .hospital,
        "health": .hospital,
        "pharmacy": .pharmacy,
        "drugstore": .pharmacy,
        
        // Shopping
        "grocery_or_supermarket": .foodMarket,
        "supermarket": .foodMarket,
        "market": .foodMarket,
        "shopping_mall": .shopping,
        "store": .shopping,
        "department_store": .shopping,
        "clothing_store": .shopping,
        "electronics_store": .shopping,
        "furniture_store": .shopping,
        "hardware_store": .shopping,
        "jewelry_store": .shopping,
        "shoe_store": .shopping
    ]
    
    // MARK: - Public Methods
    
    /// Get category information from Google Places types
    static func category(for googleTypes: [String]) -> (subcategory: Subcategory, mainCategory: MainCategory, color: Color, icon: Image) {
        // Try to find a matching subcategory from the Google types
        for type in googleTypes {
            if let subcategory = googleTypeMappings[type] {
                let mainCategory = subcategory.mainCategory
                return (subcategory, mainCategory, mainCategory.color, subcategory.icon)
            }
        }
        
        // Default to general location if no match found
        let defaultSubcategory = Subcategory.location
        let defaultMainCategory = defaultSubcategory.mainCategory
        return (defaultSubcategory, defaultMainCategory, defaultMainCategory.color, defaultSubcategory.icon)
    }
    
    /// Get formatted category name from Google types
    static func formattedCategoryName(for googleTypes: [String]) -> String {
        let categoryInfo = category(for: googleTypes)
        return categoryInfo.subcategory.rawValue
    }
    
    /// Get main category color
    static func categoryColor(for googleTypes: [String]) -> Color {
        let categoryInfo = category(for: googleTypes)
        return categoryInfo.color
    }
    
    /// Get subcategory icon
    static func categoryIcon(for googleTypes: [String]) -> Image {
        let categoryInfo = category(for: googleTypes)
        return categoryInfo.icon
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: 0) {
            // Travel examples
            ListItem.searchResult(
                title: CategoryStyle.formattedCategoryName(for: ["airport"]),
                distance: "sky100",
                location: "airplane",
                icon: CategoryStyle.categoryIcon(for: ["airport"]),
                iconColor: CategoryStyle.categoryColor(for: ["airport"]),
                onOpenPlaceDetails: {}
            )
            
            ListItem.searchResult(
                title: CategoryStyle.formattedCategoryName(for: ["hotel"]),
                distance: "sky100",
                location: "bed.double.fill",
                icon: CategoryStyle.categoryIcon(for: ["hotel"]),
                iconColor: CategoryStyle.categoryColor(for: ["hotel"]),
                onOpenPlaceDetails: {}
            )
            
            ListItem.searchResult(
                title: CategoryStyle.formattedCategoryName(for: ["car_rental"]),
                distance: "sky100",
                location: "car.fill",
                icon: CategoryStyle.categoryIcon(for: ["car_rental"]),
                iconColor: CategoryStyle.categoryColor(for: ["car_rental"]),
                onOpenPlaceDetails: {}
            )
            
            // Food & Drink examples
            ListItem.searchResult(
                title: CategoryStyle.formattedCategoryName(for: ["cafe"]),
                distance: "orange100",
                location: "cup.and.saucer.fill",
                icon: CategoryStyle.categoryIcon(for: ["cafe"]),
                iconColor: CategoryStyle.categoryColor(for: ["cafe"]),
                onOpenPlaceDetails: {}
            )
            
            ListItem.searchResult(
                title: CategoryStyle.formattedCategoryName(for: ["restaurant"]),
                distance: "orange100",
                location: "fork.knife",
                icon: CategoryStyle.categoryIcon(for: ["restaurant"]),
                iconColor: CategoryStyle.categoryColor(for: ["restaurant"]),
                onOpenPlaceDetails: {}
            )
            
            ListItem.searchResult(
                title: CategoryStyle.formattedCategoryName(for: ["bakery"]),
                distance: "orange100",
                location: "birthday.cake.fill",
                icon: CategoryStyle.categoryIcon(for: ["bakery"]),
                iconColor: CategoryStyle.categoryColor(for: ["bakery"]),
                onOpenPlaceDetails: {}
            )
            
            ListItem.searchResult(
                title: CategoryStyle.formattedCategoryName(for: ["bar"]),
                distance: "orange100",
                location: "wineglass.fill",
                icon: CategoryStyle.categoryIcon(for: ["bar"]),
                iconColor: CategoryStyle.categoryColor(for: ["bar"]),
                onOpenPlaceDetails: {}
            )
            
            // Art & Fun examples
            ListItem.searchResult(
                title: CategoryStyle.formattedCategoryName(for: ["museum"]),
                distance: "purple100",
                location: "building.columns.fill",
                icon: CategoryStyle.categoryIcon(for: ["museum"]),
                iconColor: CategoryStyle.categoryColor(for: ["museum"]),
                onOpenPlaceDetails: {}
            )
            
            ListItem.searchResult(
                title: CategoryStyle.formattedCategoryName(for: ["movie_theater"]),
                distance: "purple100",
                location: "film.fill",
                icon: CategoryStyle.categoryIcon(for: ["movie_theater"]),
                iconColor: CategoryStyle.categoryColor(for: ["movie_theater"]),
                onOpenPlaceDetails: {}
            )
            
            ListItem.searchResult(
                title: CategoryStyle.formattedCategoryName(for: ["amusement_park"]),
                distance: "purple100",
                location: "star.fill",
                icon: CategoryStyle.categoryIcon(for: ["amusement_park"]),
                iconColor: CategoryStyle.categoryColor(for: ["amusement_park"]),
                onOpenPlaceDetails: {}
            )
            
            // Outdoor examples
            ListItem.searchResult(
                title: CategoryStyle.formattedCategoryName(for: ["park"]),
                distance: "green100",
                location: "leaf.fill",
                icon: CategoryStyle.categoryIcon(for: ["park"]),
                iconColor: CategoryStyle.categoryColor(for: ["park"]),
                onOpenPlaceDetails: {}
            )
            
            ListItem.searchResult(
                title: CategoryStyle.formattedCategoryName(for: ["beach"]),
                distance: "green100",
                location: "beach.umbrella.fill",
                icon: CategoryStyle.categoryIcon(for: ["beach"]),
                iconColor: CategoryStyle.categoryColor(for: ["beach"]),
                onOpenPlaceDetails: {}
            )
            
            ListItem.searchResult(
                title: CategoryStyle.formattedCategoryName(for: ["campground"]),
                distance: "green100",
                location: "tent.fill",
                icon: CategoryStyle.categoryIcon(for: ["campground"]),
                iconColor: CategoryStyle.categoryColor(for: ["campground"]),
                onOpenPlaceDetails: {}
            )
            
            // Work & Study examples
            ListItem.searchResult(
                title: CategoryStyle.formattedCategoryName(for: ["library"]),
                distance: "blue100",
                location: "books.vertical.fill",
                icon: CategoryStyle.categoryIcon(for: ["library"]),
                iconColor: CategoryStyle.categoryColor(for: ["library"]),
                onOpenPlaceDetails: {}
            )
            
            ListItem.searchResult(
                title: CategoryStyle.formattedCategoryName(for: ["university"]),
                distance: "blue100",
                location: "building.2.fill",
                icon: CategoryStyle.categoryIcon(for: ["university"]),
                iconColor: CategoryStyle.categoryColor(for: ["university"]),
                onOpenPlaceDetails: {}
            )
            
            // Sports examples
            ListItem.searchResult(
                title: CategoryStyle.formattedCategoryName(for: ["gym"]),
                distance: "red100",
                location: "figure.run",
                icon: CategoryStyle.categoryIcon(for: ["gym"]),
                iconColor: CategoryStyle.categoryColor(for: ["gym"]),
                onOpenPlaceDetails: {}
            )
            
            ListItem.searchResult(
                title: CategoryStyle.formattedCategoryName(for: ["stadium"]),
                distance: "red100",
                location: "sportscourt.fill",
                icon: CategoryStyle.categoryIcon(for: ["stadium"]),
                iconColor: CategoryStyle.categoryColor(for: ["stadium"]),
                onOpenPlaceDetails: {}
            )
            
            // Services examples
            ListItem.searchResult(
                title: CategoryStyle.formattedCategoryName(for: ["bank"]),
                distance: "teal100",
                location: "building.columns.fill",
                icon: CategoryStyle.categoryIcon(for: ["bank"]),
                iconColor: CategoryStyle.categoryColor(for: ["bank"]),
                onOpenPlaceDetails: {}
            )
            
            ListItem.searchResult(
                title: CategoryStyle.formattedCategoryName(for: ["gas_station"]),
                distance: "teal100",
                location: "fuelpump.fill",
                icon: CategoryStyle.categoryIcon(for: ["gas_station"]),
                iconColor: CategoryStyle.categoryColor(for: ["gas_station"]),
                onOpenPlaceDetails: {}
            )
            
            ListItem.searchResult(
                title: CategoryStyle.formattedCategoryName(for: ["atm"]),
                distance: "teal100",
                location: "creditcard.fill",
                icon: CategoryStyle.categoryIcon(for: ["atm"]),
                iconColor: CategoryStyle.categoryColor(for: ["atm"]),
                onOpenPlaceDetails: {}
            )
            
            ListItem.searchResult(
                title: CategoryStyle.formattedCategoryName(for: ["bus_station"]),
                distance: "teal100",
                location: "bus.fill",
                icon: CategoryStyle.categoryIcon(for: ["bus_station"]),
                iconColor: CategoryStyle.categoryColor(for: ["bus_station"]),
                onOpenPlaceDetails: {}
            )
            
            // Health examples
            ListItem.searchResult(
                title: CategoryStyle.formattedCategoryName(for: ["pharmacy"]),
                distance: "aqua100",
                location: "pills.fill",
                icon: CategoryStyle.categoryIcon(for: ["pharmacy"]),
                iconColor: CategoryStyle.categoryColor(for: ["pharmacy"]),
                onOpenPlaceDetails: {}
            )
            
            ListItem.searchResult(
                title: CategoryStyle.formattedCategoryName(for: ["hospital"]),
                distance: "aqua100",
                location: "cross.circle.fill",
                icon: CategoryStyle.categoryIcon(for: ["hospital"]),
                iconColor: CategoryStyle.categoryColor(for: ["hospital"]),
                onOpenPlaceDetails: {}
            )
            
            // Shopping examples
            ListItem.searchResult(
                title: CategoryStyle.formattedCategoryName(for: ["grocery_or_supermarket"]),
                distance: "yellow100",
                location: "cart.fill",
                icon: CategoryStyle.categoryIcon(for: ["grocery_or_supermarket"]),
                iconColor: CategoryStyle.categoryColor(for: ["grocery_or_supermarket"]),
                onOpenPlaceDetails: {}
            )
            
            ListItem.searchResult(
                title: CategoryStyle.formattedCategoryName(for: ["shopping_mall"]),
                distance: "yellow100",
                location: "bag.fill",
                icon: CategoryStyle.categoryIcon(for: ["shopping_mall"]),
                iconColor: CategoryStyle.categoryColor(for: ["shopping_mall"]),
                onOpenPlaceDetails: {}
            )
            
            // Unknown/General location
            ListItem.searchResult(
                title: CategoryStyle.formattedCategoryName(for: ["unknown_type"]),
                distance: "grey100",
                location: "mappin.circle.fill",
                icon: CategoryStyle.categoryIcon(for: ["unknown_type"]),
                iconColor: CategoryStyle.categoryColor(for: ["unknown_type"]),
                onOpenPlaceDetails: {}
            )
        }
    }
} 