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

                
                VStack {
                    if viewModel.isLoading {
                        ProgressView("Fetching Weather...")
                            .scaleEffect(1.5)
                            .tint(.white)
                            .foregroundColor(.white)
                        
                    } else if let weather = viewModel.currentWeather {
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 34) {
                                
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
                                
                                NavigationLink(destination: HourlyForecastView(viewModel: viewModel)) {
                                    ThreeDayForecastView(forecastDays: weather.forecast.forecastday, isMorning: viewModel.isMorning)
                                        .padding(.horizontal, 20)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                WeatherGridDetailsView(weather: weather, isMorning: viewModel.isMorning)
                                    .padding(.horizontal, 4)
                                    .padding(.bottom, 30)
                            }
                        }
                        
                    } else if let error = viewModel.errorMessage {
                        ErrorStateView(message: error) {
                            viewModel.loadWeatherData()
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FavoritesView(homeViewModel: viewModel)) {
                        Image(systemName: "list.bullet")
                            .font(.title3)
                            .foregroundColor( .white)
                    }
                }
            }
        }
        .onAppear {
            let initialCity = favoriteLocations.last?.name ?? "London"
            viewModel.loadWeatherData(for: initialCity)
            
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
