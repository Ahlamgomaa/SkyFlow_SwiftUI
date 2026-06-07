import SwiftUI
import SwiftData

struct WeatherDetailsContentView: View {
    @Bindable var viewModel: HomeViewModel
    var favoriteLocations: [FavoriteCity]
    var modelContext: ModelContext
    var cityName: String
    
    @State private var networkMonitor = NetworkMonitor.shared

    var body: some View {
        ZStack {
            VideoBackgroundView(videoName: viewModel.backgroundVideoName)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                if !networkMonitor.isConnected {
                    Spacer()
                    NoConnectionView(viewModel: viewModel)
                        .transition(.opacity.combined(with: .scale))
                    Spacer()
                } else if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.white)
                        .foregroundColor(.white)
                    Spacer()
                    
                } else if let weather = viewModel.currentWeather {
                    
                    let isCurrentCityFavorite = favoriteLocations.contains { $0.name.lowercased() == cityName.lowercased() }

                    let displayName = cityName.isEmpty ? weather.location.name : cityName

                    TopWeatherDivisionView(
                    
                        weather: weather,
                        isMorning: viewModel.isMorning,
                        isFavorite: isCurrentCityFavorite, cityName: cityName,
                        onFavoriteTapped: {
                            if let existing = favoriteLocations.first(where: { $0.name.lowercased() == displayName.lowercased() }) {
                                modelContext.delete(existing)
                            } else {
                                modelContext.insert(FavoriteCity(name: displayName,
                                                                 latitude: weather.location.lat,
                                                                 longitude: weather.location.lon,
                                                              ))
                            }
                            try? modelContext.save()
                        }
                    )
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 20) {
                            ThreeDayForecastView(
                                forecastDays: weather.forecast.forecastday,
                                isMorning: viewModel.isMorning,
                                currentTemp: weather.current.tempC,
                                viewModel: viewModel
                            )
                            .padding(.horizontal, 10)
                            
                            WeatherGridDetailsView(weather: weather, isMorning: viewModel.isMorning)
                                .padding(.horizontal, 4)
                                .padding(.bottom, 16)
                        }
                        .padding(.top, 16)
                    }
                    .safeAreaPadding(.bottom)
                    
                } else if let error = viewModel.errorMessage {
                    Spacer()
                    ErrorStateView(message: error) {
                        viewModel.loadWeatherData()
                    }
                    Spacer()
                }
            }
        }
        .animation(.easeInOut, value: networkMonitor.isConnected)
    }
}
