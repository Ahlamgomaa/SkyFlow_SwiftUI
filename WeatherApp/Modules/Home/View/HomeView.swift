import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    
    @Environment(\.modelContext) private var modelContext
    @Query private var favoriteLocations: [FavoriteCity]
    
    var body: some View {
        NavigationStack {
            ZStack {
                VideoBackgroundView(videoName: viewModel.backgroundVideoName)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    if viewModel.isLoading {
                        Spacer()
                            .scaleEffect(1.5)
                            .tint(.white)
                            .foregroundColor(.white)
                        Spacer()
                        
                    } else if let weather = viewModel.currentWeather {
                        
                        let isCurrentCityFavorite = favoriteLocations.contains { $0.name.lowercased() == weather.location.name.lowercased() }

                        TopWeatherDivisionView(
                            weather: weather,
                            isMorning: viewModel.isMorning,
                            isFavorite: isCurrentCityFavorite,
                            onFavoriteTapped: {
                                if let existing = favoriteLocations.first(where: { $0.name.lowercased() == weather.location.name.lowercased() }) {
                                    modelContext.delete(existing)
                                } else {
                                    modelContext.insert(FavoriteCity(name: weather.location.name))
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
                                .padding(.horizontal, 20)
                                
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FavoritesView(homeViewModel: viewModel)) {
                        Image(systemName: "list.bullet")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .onAppear {
            let initialCity = favoriteLocations.last?.name ?? "Cairo"
            viewModel.loadWeatherData(for: initialCity)
            
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
