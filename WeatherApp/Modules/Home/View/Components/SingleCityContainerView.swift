import SwiftUI
import SwiftData
struct SingleCityContainerView: View {
    let cityName: String
    var favoriteLocations: [FavoriteCity]
    var modelContext: ModelContext
    
    @State private var singleViewModel = HomeViewModel()
    
    var body: some View {
        WeatherDetailsContentView(
            viewModel: singleViewModel,
            favoriteLocations: favoriteLocations,
            modelContext: modelContext
        )
        .onAppear {
            singleViewModel.loadWeatherData(for: cityName)
        }
    }
}
