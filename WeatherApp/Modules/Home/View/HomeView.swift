import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    
    @Environment(\.modelContext) private var modelContext
    @Query private var favoriteLocations: [FavoriteCity]
    
    var body: some View {
        NavigationStack {
            WeatherDetailsContentView(
                viewModel: viewModel,
                favoriteLocations: favoriteLocations,
                modelContext: modelContext
            )
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
