# 🌦️ SunnyOrNot

**SunnyOrNot** is a weather application built following **Clean Architecture** and the **BLoC pattern**. It provides current and 10-day forecast, providing both GPS data and city-based search.

## Key Features

*   **GPS Integration:** Fetches real-time weather using the device coordinates via [geolocator](https://pub.dev/packages/geolocator).
*   **City Search:** Translates city names to coordinates to show weather data for any location.
*   **10-Day Forecast:** Displays daily weather info (max/min temp) sourced from the [Open-Meteo API](https://open-meteo.com).
*   **Map:** Visualizes the selected location on a map, providing geographical context for the current weather data.

## Core Dependencies

*   **State Management:**
    *   [`flutter_bloc`](https://pub.dev/packages/flutter_bloc): Business logic and state separation.
    *   [`equatable`](https://pub.dev/packages/equatable): Value based equality for states and entities.
*   **Dependency Injection:**
    *   [`get_it`](https://pub.dev/packages/get_it): Service locator for decoupling classes and simpler unit testing.
*   **Networking:**
    *   [`http`](https://pub.dev/packages/http): Package for making HTTP requests.
    *   [`Open-Meteo API`](https://open-meteo.com): Source for weather data, forecasts and location to coordinates translation.
*   **Data/Error Handling:**
    *   [`dartz`](https://pub.dev/packages/dartz): Implements `Either` for success/failure handling.
*   **Testing:**
    *   [`bloc_test`](https://pub.dev/packages/bloc_test): Testing library for BLoCs.
    *   [`mocktail`](https://pub.dev/packages/mocktail): Mocking library for unit tests.
*   **Maps/Location:**
    *   [`flutter_map`](https://pub.dev/packages/flutter_map): Integration of a map to visualize weather locations.
    *   [`geolocator`](https://pub.dev/packages/geolocator): GPS coordinate retrieval and permission management.
    *   [`latlong2`](https://pub.dev/packages/latlong2): Package for basic latitude/longitude utilities, used by the flutter_map package.

## Complete Project Structure (Feature-First)

```text
lib/
├── core/
│   ├── error/              # Services exceptions and Domain failures
│   └── presentation/       # Reusable or shared components
└── features/
    ├── weather/            # Weather flow
    │   └── ...
    ├── location/           # City search
    │   └── ...
    └── gps/                # Geolocation logic
        └── ...
```
## Subfolder Structure (Inside Each Feature)

```text
weather/            # Main feature
├── data/           # DTOs, repositories implementations, and data sources
├── domain/         # Entities, repositories interfaces, and use cases
└── presentation/   # Screens, widgets, and blocs
```

## To Get Started

Follow this steps to run the app
1. Clone the repository
```text
git clone https://github.com/juanpipereira/sunny_or_not.git
```
3. Get dependencies
```text
flutter pub get
```
5. Run the app
```text
flutter run
```
