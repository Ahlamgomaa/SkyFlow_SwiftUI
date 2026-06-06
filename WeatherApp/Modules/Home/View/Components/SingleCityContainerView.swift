import SwiftUI
import SwiftData

struct SingleCityContainerView: View {
    let cityName: String
    let latitude: Double
    let longitude: Double
    var favoriteLocations: [FavoriteCity]
    var modelContext: ModelContext
    
    @State private var singleViewModel = HomeViewModel()
    
    var body: some View {
        WeatherDetailsContentView(
            viewModel: singleViewModel,
            favoriteLocations: favoriteLocations,
            modelContext: modelContext,
            cityName: cityName 
        )
        .onAppear {
            singleViewModel.loadWeatherData(lat: latitude, lon: longitude)
        }
    }
}
