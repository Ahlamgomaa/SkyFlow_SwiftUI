# ☁️ SkyLogic

### SwiftUI · iOS · MVVM

**SkyLogic** is a beautifully crafted iOS weather application that lets you track real-time weather conditions for any location around the world—complete with offline support, smart caching, and a premium animated UI.


## ✨ Features

- **Real-Time Weather Dashboard** — Current temperature, conditions, high/low, and animated weather icons for any location.
- **3-Day Forecast** — Daily forecast cards with min/max temperature gradient bars and a current temperature indicator dot.
- **Hourly Forecast** — Scroll through every hour of the day with time-accurate weather icons and temperatures.
- **City Search & Favorites** — Search any city worldwide and save your favorites for instant offline access.
- **Smart Offline Support** — Powered by `NWPathMonitor`, the app detects connection loss in real time and displays a dedicated offline card. Cached data is served via `URLCache` so previously loaded weather is always available.
- **Dynamic Video Backgrounds** — Morning and evening video themes that adapt automatically based on the time of day.
- **Animated Splash Screen** — A polished entry experience before reaching the main dashboard.
- **Location-Based Weather** — Automatically fetches weather for your current GPS location using `CoreLocation`.
- **Swipe to Delete Favorites** — Intuitive swipe actions in the favorites list.


## 🛠️ Tech Stack & Architecture

Built entirely in **Swift** using the **MVVM (Model–View–ViewModel)** architectural pattern for clean separation of concerns and testability.

| Layer | Technology |
|---|---|
| **UI** | SwiftUI (Declarative UI, TabView, NavigationStack) |
| **State Management** | `@Observable` macro (Swift 5.9 Observation framework) |
| **Networking** | Native `URLSession` with `URLCache` (memory + disk) |
| **Local Storage** | **SwiftData** (`@Model`, `ModelContainer`, `@Query`) |
| **Location** | `CoreLocation` + Reverse Geocoding |
| **Network Monitoring** | `Network` framework (`NWPathMonitor`) |
| **Video Playback** | `AVKit` for dynamic video backgrounds |
| **Weather Data** | [WeatherAPI.com](https://www.weatherapi.com) |



## 🏗️ Project Structure


WeatherApp/
├── Core/
│   ├── LocationManager.swift       # CLLocation wrapper with @Observable
│   └── NetworkMonitor.swift        # NWPathMonitor real-time connectivity
│
├── Data/
│   ├── Entities/
│   │   ├── CurrentWeather.swift    # Decodable weather response models
│   │   ├── FavoriteCity.swift      # SwiftData @Model for saved cities
│   │   ├── ForecastData.swift      # Forecast & hourly data models
│   │   └── SearchResult.swift      # City search result model
│   ├── Network/
│   │   ├── NetworkClient.swift     # Protocol definition
│   │   └── NetworkClientImp.swift  # URLSession + URLCache implementation
│   ├── Services/Remote/
│   │   ├── WeatherServices.swift   # Service protocol
│   │   └── WeatherServicesImp.swift # WeatherAPI.com integration
│   └── Repos/
│       └── WeatherRepository.swift # Repository pattern abstraction
│
├── Modules/
│   ├── Splash/                     # Animated splash screen
│   ├── Home/                       # Main weather dashboard (TabView)
│   ├── Details/                    # Hourly forecast drill-down
│   ├── FavoriteLocation/           # Saved cities list
│   ├── AddCity/                    # City search & add flow
│   └── NoConnection/               # Offline state card
│
└── Utlis/
    ├── Components/
    │   └── VideoBackgroundView.swift
    └── View/
        └── WeatherDetailsContentView.swift



## 🚀 Getting Started

**1. Clone the repository:**

git clone https://github.com/Ahlamgomaa/SkyFlow_SwiftUI.git


**2. Open the project in Xcode:**

cd SkyFlow_SwiftUI
open WeatherApp.xcodeproj


**3. Add your API Key:**

Open `WeatherApp/Data/Services/Remote/WeatherServicesImp.swift` and replace the `apiKey` value with your own key from [weatherapi.com](https://www.weatherapi.com/my/):


private let apiKey = "YOUR_API_KEY_HERE"


**4. Build & Run** on a simulator or physical device (iOS 17+).

> ⚠️ **Note:** Location features require a physical device or a simulator with a simulated location set.


## 📋 Requirements

| Requirement | Version |
|---|---|
| iOS | 17.0+ |
| Xcode | 15.0+ |
| Swift | 5.9+ |


## 🎓 Acknowledgments

This project was developed as part of a SwiftUI learning journey.

**Developer:** Ahlam Gomaa
