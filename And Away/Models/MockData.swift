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
            name: "Le Comptoir du 7ème",
            formattedAddress: "8 Avenue Bosquet, 75007 Paris, France",
            formattedPhoneNumber: "+33 1 45 51 78 96",
            internationalPhoneNumber: "+33 1 45 51 78 96",
            website: "https://www.lecomptoirdu7.com",
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