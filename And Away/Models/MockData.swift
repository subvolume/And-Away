import Foundation

// MARK: - Mock Data for Testing UI
struct MockData {
    
    // MARK: - Autocomplete Mock Data
    static let sampleAutocompleteResponse = GoogleAutocompleteResponse(
        predictions: [
            AutocompletePrediction(
                placeId: "ChIJD7fiBh9u5kcRYJSMaMOCCwQ",
                description: "Paris, France",
                structuredFormatting: StructuredFormatting(
                    mainText: "Paris",
                    secondaryText: "France"
                ),
                types: ["locality", "political"]
            ),
            AutocompletePrediction(
                placeId: "ChIJLU7jZClu5kcR4PcOOO6p3I0",
                description: "Eiffel Tower, Paris, France",
                structuredFormatting: StructuredFormatting(
                    mainText: "Eiffel Tower",
                    secondaryText: "Paris, France"
                ),
                types: ["tourist_attraction", "point_of_interest"]
            ),
            AutocompletePrediction(
                placeId: "ChIJ343bZClu5kcRVQOGgQOGcwQ",
                description: "Louvre Museum, Paris, France",
                structuredFormatting: StructuredFormatting(
                    mainText: "Louvre Museum",
                    secondaryText: "Paris, France"
                ),
                types: ["museum", "tourist_attraction"]
            ),
            AutocompletePrediction(
                placeId: "ChIJL-ROikVu5kcRzWBvNS3lnM0",
                description: "Notre-Dame de Paris, Paris, France",
                structuredFormatting: StructuredFormatting(
                    mainText: "Notre-Dame de Paris",
                    secondaryText: "Paris, France"
                ),
                types: ["church", "place_of_worship"]
            )
        ],
        status: "OK"
    )
    
    // MARK: - Places Search Mock Data
    static let sampleSearchResponse = GooglePlacesSearchResponse(
        results: [
            PlaceSearchResult(
                placeId: "ChIJL-ROikVu5kcRzWBvNS3lnM0",
                name: "Le Comptoir du Crème",
                vicinity: "8 Avenue Bosquet, Paris",
                rating: 4.5,
                priceLevel: 2,
                photos: [
                    PlacePhoto(photoReference: "mock_photo_ref_1", height: 1080, width: 1920)
                ],
                geometry: PlaceGeometry(
                    location: PlaceLocation(lat: 48.8566, lng: 2.3522),
                    viewport: PlaceViewport(
                        northeast: PlaceLocation(lat: 48.8580, lng: 2.3540),
                        southwest: PlaceLocation(lat: 48.8552, lng: 2.3504)
                    )
                ),
                types: ["restaurant", "food", "point_of_interest"],
                userRatingsTotal: 1247,
                businessStatus: "OPERATIONAL"
            ),
            PlaceSearchResult(
                placeId: "ChIJD7fiBh9u5kcRYJSMaMOCCwQ",
                name: "Café de Flore",
                vicinity: "172 Boulevard Saint-Germain, Paris",
                rating: 4.2,
                priceLevel: 3,
                photos: [
                    PlacePhoto(photoReference: "mock_photo_ref_2", height: 1080, width: 1920)
                ],
                geometry: PlaceGeometry(
                    location: PlaceLocation(lat: 48.8542, lng: 2.3320),
                    viewport: nil
                ),
                types: ["cafe", "restaurant", "food"],
                userRatingsTotal: 2156,
                businessStatus: "OPERATIONAL"
            ),
            PlaceSearchResult(
                placeId: "ChIJ343bZClu5kcRVQOGgQOGcwQ",
                name: "L'As du Fallafel",
                vicinity: "34 Rue des Rosiers, Paris",
                rating: 4.3,
                priceLevel: 1,
                photos: nil,
                geometry: PlaceGeometry(
                    location: PlaceLocation(lat: 48.8571, lng: 2.3617),
                    viewport: nil
                ),
                types: ["restaurant", "food", "meal_takeaway"],
                userRatingsTotal: 3890,
                businessStatus: "OPERATIONAL"
            )
        ],
        status: "OK",
        nextPageToken: "mock_next_page_token"
    )
    
    // MARK: - Place Details Mock Data
    static let samplePlaceDetails = GooglePlaceDetailsResponse(
        result: PlaceDetails(
            placeId: "ChIJL-ROikVu5kcRzWBvNS3lnM0",
            name: "Le Comptoir du Crème",
            formattedAddress: "8 Avenue Bosquet, 75007 Paris, France",
            formattedPhoneNumber: "+33 1 45 51 78 96",
            internationalPhoneNumber: "+33 1 45 51 78 96",
            website: "https://www.lecomptoirducreme.com",
            rating: 4.5,
            userRatingsTotal: 1247,
            priceLevel: 2,
            photos: [
                PlacePhoto(photoReference: "mock_photo_ref_1", height: 1080, width: 1920),
                PlacePhoto(photoReference: "mock_photo_ref_2", height: 720, width: 1280)
            ],
            reviews: [
                PlaceReview(
                    authorName: "Sarah M.",
                    authorUrl: nil,
                    language: "en",
                    profilePhotoUrl: "https://example.com/profile1.jpg",
                    rating: 5,
                    relativeTimeDescription: "2 weeks ago",
                    text: "Amazing traditional French bistro! The coq au vin was incredible and the service was impeccable. Perfect for a romantic dinner.",
                    time: 1699876543
                ),
                PlaceReview(
                    authorName: "Jean D.",
                    authorUrl: nil,
                    language: "fr",
                    profilePhotoUrl: nil,
                    rating: 4,
                    relativeTimeDescription: "1 month ago",
                    text: "Excellent food, though a bit pricey. The atmosphere is very authentic and the wine selection is impressive.",
                    time: 1697284543
                ),
                PlaceReview(
                    authorName: "Maria L.",
                    authorUrl: nil,
                    language: "en",
                    profilePhotoUrl: "https://example.com/profile3.jpg",
                    rating: 5,
                    relativeTimeDescription: "3 days ago",
                    text: "Best meal we had in Paris! The staff spoke excellent English and helped us choose the perfect wine pairing.",
                    time: 1700123456
                )
            ],
            openingHours: OpeningHours(
                openNow: true,
                periods: [
                    OpeningPeriod(close: DayTime(day: 1, time: "2200"), open: DayTime(day: 1, time: "1200")),
                    OpeningPeriod(close: DayTime(day: 2, time: "2200"), open: DayTime(day: 2, time: "1200")),
                    OpeningPeriod(close: DayTime(day: 3, time: "2200"), open: DayTime(day: 3, time: "1200")),
                    OpeningPeriod(close: DayTime(day: 4, time: "2200"), open: DayTime(day: 4, time: "1200")),
                    OpeningPeriod(close: DayTime(day: 5, time: "2300"), open: DayTime(day: 5, time: "1200")),
                    OpeningPeriod(close: DayTime(day: 6, time: "2300"), open: DayTime(day: 6, time: "1200"))
                ],
                weekdayText: [
                    "Monday: 12:00 PM – 10:00 PM",
                    "Tuesday: 12:00 PM – 10:00 PM",
                    "Wednesday: 12:00 PM – 10:00 PM",
                    "Thursday: 12:00 PM – 10:00 PM",
                    "Friday: 12:00 PM – 11:00 PM",
                    "Saturday: 12:00 PM – 11:00 PM",
                    "Sunday: Closed"
                ]
            ),
            geometry: PlaceGeometry(
                location: PlaceLocation(lat: 48.8566, lng: 2.3522),
                viewport: PlaceViewport(
                    northeast: PlaceLocation(lat: 48.8580, lng: 2.3540),
                    southwest: PlaceLocation(lat: 48.8552, lng: 2.3504)
                )
            ),
            types: ["restaurant", "food", "point_of_interest"],
            businessStatus: "OPERATIONAL",
            utcOffset: 60
        ),
        status: "OK"
    )
    
    // MARK: - All Place Details (organized by placeId for easy lookup)
    static let allPlaceDetails: [String: PlaceDetails] = [
        "ChIJL-ROikVu5kcRzWBvNS3lnM0": PlaceDetails(
            placeId: "ChIJL-ROikVu5kcRzWBvNS3lnM0",
            name: "Le Comptoir du Crème",
            formattedAddress: "8 Avenue Bosquet, 75007 Paris, France",
            formattedPhoneNumber: "+33 1 45 51 78 96",
            internationalPhoneNumber: "+33 1 45 51 78 96",
            website: "https://www.lecomptoirducreme.com",
            rating: 4.5,
            userRatingsTotal: 1247,
            priceLevel: 2,
            photos: [
                PlacePhoto(photoReference: "mock_photo_ref_1", height: 1080, width: 1920),
                PlacePhoto(photoReference: "mock_photo_ref_2", height: 720, width: 1280)
            ],
            reviews: [
                PlaceReview(
                    authorName: "Sarah M.",
                    authorUrl: nil,
                    language: "en",
                    profilePhotoUrl: "https://example.com/profile1.jpg",
                    rating: 5,
                    relativeTimeDescription: "2 weeks ago",
                    text: "Amazing traditional French bistro! The coq au vin was incredible and the service was impeccable. Perfect for a romantic dinner.",
                    time: 1699876543
                ),
                PlaceReview(
                    authorName: "Jean D.",
                    authorUrl: nil,
                    language: "fr",
                    profilePhotoUrl: nil,
                    rating: 4,
                    relativeTimeDescription: "1 month ago",
                    text: "Excellent food, though a bit pricey. The atmosphere is very authentic and the wine selection is impressive.",
                    time: 1697284543
                )
            ],
            openingHours: OpeningHours(
                openNow: true,
                periods: [
                    OpeningPeriod(close: DayTime(day: 1, time: "2200"), open: DayTime(day: 1, time: "1200")),
                    OpeningPeriod(close: DayTime(day: 2, time: "2200"), open: DayTime(day: 2, time: "1200")),
                    OpeningPeriod(close: DayTime(day: 3, time: "2200"), open: DayTime(day: 3, time: "1200")),
                    OpeningPeriod(close: DayTime(day: 4, time: "2200"), open: DayTime(day: 4, time: "1200")),
                    OpeningPeriod(close: DayTime(day: 5, time: "2300"), open: DayTime(day: 5, time: "1200")),
                    OpeningPeriod(close: DayTime(day: 6, time: "2300"), open: DayTime(day: 6, time: "1200"))
                ],
                weekdayText: [
                    "Monday: 12:00 PM – 10:00 PM",
                    "Tuesday: 12:00 PM – 10:00 PM",
                    "Wednesday: 12:00 PM – 10:00 PM", 
                    "Thursday: 12:00 PM – 10:00 PM",
                    "Friday: 12:00 PM – 11:00 PM",
                    "Saturday: 12:00 PM – 11:00 PM",
                    "Sunday: Closed"
                ]
            ),
            geometry: PlaceGeometry(
                location: PlaceLocation(lat: 48.8566, lng: 2.3522),
                viewport: PlaceViewport(
                    northeast: PlaceLocation(lat: 48.8580, lng: 2.3540),
                    southwest: PlaceLocation(lat: 48.8552, lng: 2.3504)
                )
            ),
            types: ["restaurant", "food", "point_of_interest"],
            businessStatus: "OPERATIONAL",
            utcOffset: 60
        ),
        
        "ChIJD7fiBh9u5kcRYJSMaMOCCwQ": PlaceDetails(
            placeId: "ChIJD7fiBh9u5kcRYJSMaMOCCwQ",
            name: "Café de Flore",
            formattedAddress: "172 Boulevard Saint-Germain, 75006 Paris, France",
            formattedPhoneNumber: "+33 1 45 48 55 26",
            internationalPhoneNumber: "+33 1 45 48 55 26",
            website: "https://www.cafedeflore.fr",
            rating: 4.2,
            userRatingsTotal: 2156,
            priceLevel: 3,
            photos: [
                PlacePhoto(photoReference: "mock_flore_photo_1", height: 1080, width: 1920),
                PlacePhoto(photoReference: "mock_flore_photo_2", height: 720, width: 1280)
            ],
            reviews: [
                PlaceReview(
                    authorName: "Emma R.",
                    authorUrl: nil,
                    language: "en",
                    profilePhotoUrl: "https://example.com/profile4.jpg",
                    rating: 4,
                    relativeTimeDescription: "1 week ago",
                    text: "Historic café with great atmosphere! A bit touristy but the coffee is excellent and you can feel the literary history.",
                    time: 1700234567
                ),
                PlaceReview(
                    authorName: "Pierre L.",
                    authorUrl: nil,
                    language: "fr",
                    profilePhotoUrl: nil,
                    rating: 5,
                    relativeTimeDescription: "3 weeks ago",
                    text: "Un classique parisien! L'ambiance est unique et le service professionnel. Un peu cher mais ça vaut le coup.",
                    time: 1699123456
                ),
                PlaceReview(
                    authorName: "David K.",
                    authorUrl: nil,
                    language: "en",
                    profilePhotoUrl: "https://example.com/profile5.jpg",
                    rating: 3,
                    relativeTimeDescription: "5 days ago",
                    text: "Famous spot but very crowded. Food is decent but overpriced. Come for the history, not the value.",
                    time: 1700456789
                )
            ],
            openingHours: OpeningHours(
                openNow: true,
                periods: [
                    OpeningPeriod(close: DayTime(day: 0, time: "0200"), open: DayTime(day: 0, time: "0700")),
                    OpeningPeriod(close: DayTime(day: 1, time: "0200"), open: DayTime(day: 1, time: "0700")),
                    OpeningPeriod(close: DayTime(day: 2, time: "0200"), open: DayTime(day: 2, time: "0700")),
                    OpeningPeriod(close: DayTime(day: 3, time: "0200"), open: DayTime(day: 3, time: "0700")),
                    OpeningPeriod(close: DayTime(day: 4, time: "0200"), open: DayTime(day: 4, time: "0700")),
                    OpeningPeriod(close: DayTime(day: 5, time: "0200"), open: DayTime(day: 5, time: "0700")),
                    OpeningPeriod(close: DayTime(day: 6, time: "0200"), open: DayTime(day: 6, time: "0700"))
                ],
                weekdayText: [
                    "Monday: 7:00 AM – 2:00 AM",
                    "Tuesday: 7:00 AM – 2:00 AM",
                    "Wednesday: 7:00 AM – 2:00 AM",
                    "Thursday: 7:00 AM – 2:00 AM",
                    "Friday: 7:00 AM – 2:00 AM",
                    "Saturday: 7:00 AM – 2:00 AM",
                    "Sunday: 7:00 AM – 2:00 AM"
                ]
            ),
            geometry: PlaceGeometry(
                location: PlaceLocation(lat: 48.8542, lng: 2.3320),
                viewport: PlaceViewport(
                    northeast: PlaceLocation(lat: 48.8556, lng: 2.3334),
                    southwest: PlaceLocation(lat: 48.8528, lng: 2.3306)
                )
            ),
            types: ["cafe", "restaurant", "food"],
            businessStatus: "OPERATIONAL",
            utcOffset: 60
        ),
        
        "ChIJ343bZClu5kcRVQOGgQOGcwQ": PlaceDetails(
            placeId: "ChIJ343bZClu5kcRVQOGgQOGcwQ",
            name: "L'As du Fallafel",
            formattedAddress: "34 Rue des Rosiers, 75004 Paris, France",
            formattedPhoneNumber: "+33 1 48 87 63 60",
            internationalPhoneNumber: "+33 1 48 87 63 60",
            website: nil,
            rating: 4.3,
            userRatingsTotal: 3890,
            priceLevel: 1,
            photos: [
                PlacePhoto(photoReference: "mock_fallafel_photo_1", height: 1080, width: 1920)
            ],
            reviews: [
                PlaceReview(
                    authorName: "Ahmed S.",
                    authorUrl: nil,
                    language: "en",
                    profilePhotoUrl: "https://example.com/profile6.jpg",
                    rating: 5,
                    relativeTimeDescription: "4 days ago",
                    text: "Best falafel in Paris! Always a queue but it moves fast. The portions are huge and incredibly flavorful.",
                    time: 1700345678
                ),
                PlaceReview(
                    authorName: "Sophie T.",
                    authorUrl: nil,
                    language: "fr",
                    profilePhotoUrl: nil,
                    rating: 4,
                    relativeTimeDescription: "2 weeks ago",
                    text: "Incontournable du Marais! Un peu d'attente mais ça vaut vraiment le coup. Les falafels sont délicieux.",
                    time: 1699567890
                ),
                PlaceReview(
                    authorName: "Michael P.",
                    authorUrl: nil,
                    language: "en",
                    profilePhotoUrl: "https://example.com/profile7.jpg",
                    rating: 4,
                    relativeTimeDescription: "1 week ago",
                    text: "Authentic Middle Eastern food in the heart of the Marais. Cash only, but worth the trip to the ATM!",
                    time: 1700012345
                )
            ],
            openingHours: OpeningHours(
                openNow: false,
                periods: [
                    OpeningPeriod(close: DayTime(day: 0, time: "2300"), open: DayTime(day: 0, time: "1200")),
                    OpeningPeriod(close: DayTime(day: 1, time: "2300"), open: DayTime(day: 1, time: "1200")),
                    OpeningPeriod(close: DayTime(day: 2, time: "2300"), open: DayTime(day: 2, time: "1200")),
                    OpeningPeriod(close: DayTime(day: 3, time: "2300"), open: DayTime(day: 3, time: "1200")),
                    OpeningPeriod(close: DayTime(day: 4, time: "2300"), open: DayTime(day: 4, time: "1200")),
                    OpeningPeriod(close: DayTime(day: 6, time: "2300"), open: DayTime(day: 6, time: "1200"))
                ],
                weekdayText: [
                    "Monday: 12:00 PM – 11:00 PM",
                    "Tuesday: 12:00 PM – 11:00 PM",
                    "Wednesday: 12:00 PM – 11:00 PM",
                    "Thursday: 12:00 PM – 11:00 PM",
                    "Friday: Closed",
                    "Saturday: 12:00 PM – 11:00 PM",
                    "Sunday: 12:00 PM – 11:00 PM"
                ]
            ),
            geometry: PlaceGeometry(
                location: PlaceLocation(lat: 48.8571, lng: 2.3617),
                viewport: PlaceViewport(
                    northeast: PlaceLocation(lat: 48.8585, lng: 2.3631),
                    southwest: PlaceLocation(lat: 48.8557, lng: 2.3603)
                )
            ),
            types: ["restaurant", "food", "meal_takeaway"],
            businessStatus: "OPERATIONAL",
            utcOffset: 60
        )
    ]
    
    // MARK: - Directions Mock Data
    static let sampleDirectionsResponse = GoogleDirectionsResponse(
        routes: [
            DirectionRoute(
                bounds: RouteBounds(
                    northeast: PlaceLocation(lat: 48.8606, lng: 2.3376),
                    southwest: PlaceLocation(lat: 48.8566, lng: 2.3522)
                ),
                legs: [
                    RouteLeg(
                        distance: RouteDistance(text: "1.2 km", value: 1200),
                        duration: RouteDuration(text: "15 mins", value: 900),
                        durationInTraffic: RouteDuration(text: "18 mins", value: 1080),
                        endAddress: "8 Avenue Bosquet, 75007 Paris, France",
                        endLocation: PlaceLocation(lat: 48.8566, lng: 2.3522),
                        startAddress: "Current Location",
                        startLocation: PlaceLocation(lat: 48.8606, lng: 2.3376),
                        steps: [
                            RouteStep(
                                distance: RouteDistance(text: "0.3 km", value: 300),
                                duration: RouteDuration(text: "4 mins", value: 240),
                                endLocation: PlaceLocation(lat: 48.8590, lng: 2.3445),
                                htmlInstructions: "Head <b>south</b> on <b>Rue de Rivoli</b> toward <b>Place Vendôme</b>",
                                polyline: RoutePolyline(points: "mock_polyline_points_1"),
                                startLocation: PlaceLocation(lat: 48.8606, lng: 2.3376),
                                travelMode: "WALKING",
                                maneuver: nil
                            ),
                            RouteStep(
                                distance: RouteDistance(text: "0.5 km", value: 500),
                                duration: RouteDuration(text: "6 mins", value: 360),
                                endLocation: PlaceLocation(lat: 48.8575, lng: 2.3480),
                                htmlInstructions: "Turn <b>right</b> onto <b>Boulevard Saint-Germain</b>",
                                polyline: RoutePolyline(points: "mock_polyline_points_2"),
                                startLocation: PlaceLocation(lat: 48.8590, lng: 2.3445),
                                travelMode: "WALKING",
                                maneuver: "turn-right"
                            ),
                            RouteStep(
                                distance: RouteDistance(text: "0.4 km", value: 400),
                                duration: RouteDuration(text: "5 mins", value: 300),
                                endLocation: PlaceLocation(lat: 48.8566, lng: 2.3522),
                                htmlInstructions: "Turn <b>left</b> onto <b>Avenue Bosquet</b><div style=\"font-size:0.9em\">Destination will be on the right</div>",
                                polyline: RoutePolyline(points: "mock_polyline_points_3"),
                                startLocation: PlaceLocation(lat: 48.8575, lng: 2.3480),
                                travelMode: "WALKING",
                                maneuver: "turn-left"
                            )
                        ]
                    )
                ],
                overviewPolyline: RoutePolyline(points: "mock_overview_polyline_points"),
                summary: "Boulevard Saint-Germain and Avenue Bosquet",
                warnings: ["Walking directions are in beta."],
                waypointOrder: nil
            )
        ],
        status: "OK",
        geocodedWaypoints: [
            GeocodedWaypoint(
                geocoderStatus: "OK",
                placeId: "ChIJL-ROikVu5kcRzWBvNS3lnM0",
                types: ["restaurant", "food", "point_of_interest"]
            )
        ]
    )
    
    // MARK: - Additional Sample Data for Variety
    static let sampleTouristAttractions = GooglePlacesSearchResponse(
        results: [
            PlaceSearchResult(
                placeId: "ChIJLU7jZClu5kcR4PcOOO6p3I0",
                name: "Eiffel Tower",
                vicinity: "Champ de Mars, 5 Avenue Anatole France, Paris",
                rating: 4.6,
                priceLevel: nil,
                photos: [
                    PlacePhoto(photoReference: "mock_eiffel_photo", height: 1080, width: 1920)
                ],
                geometry: PlaceGeometry(
                    location: PlaceLocation(lat: 48.8584, lng: 2.2945),
                    viewport: nil
                ),
                types: ["tourist_attraction", "point_of_interest"],
                userRatingsTotal: 285467,
                businessStatus: "OPERATIONAL"
            ),
            PlaceSearchResult(
                placeId: "ChIJ343bZClu5kcRVQOGgQOGcwQ",
                name: "Louvre Museum",
                vicinity: "Rue de Rivoli, Paris",
                rating: 4.7,
                priceLevel: 2,
                photos: [
                    PlacePhoto(photoReference: "mock_louvre_photo", height: 1080, width: 1920)
                ],
                geometry: PlaceGeometry(
                    location: PlaceLocation(lat: 48.8606, lng: 2.3376),
                    viewport: nil
                ),
                types: ["museum", "tourist_attraction", "point_of_interest"],
                userRatingsTotal: 195432,
                businessStatus: "OPERATIONAL"
            )
        ],
        status: "OK",
        nextPageToken: nil
    )
} 