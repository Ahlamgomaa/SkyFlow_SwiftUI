import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \FavoriteCity.timestamp, order: .forward)
    private var favoriteLocations: [FavoriteCity]
    
    @State private var displayedCities: [String] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                VideoBackgroundView(videoName: viewModel.backgroundVideoName)
                    .ignoresSafeArea()
                
                TabView {
                    SingleCityContainerView(
                        cityName: "Cairo",
                        favoriteLocations: favoriteLocations,
                        modelContext: modelContext
                    )
                    .id("Cairo-StaticPage")
                    
                    ForEach(displayedCities, id: \.self) { cityName in
                        SingleCityContainerView(
                            cityName: cityName,
                            favoriteLocations: favoriteLocations,
                            modelContext: modelContext
                        )
                        .id("\(cityName)-\(displayedCities.count)")
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .ignoresSafeArea(edges: .top)
                .id(displayedCities.joined(separator: ","))
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
            setupDisplayedCities()
            
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            
            UIPageControl.appearance().currentPageIndicatorTintColor = .white
            UIPageControl.appearance().pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.4)
        }
        .onChange(of: favoriteLocations) { _, _ in
            setupDisplayedCities()
        }
    }
    
    private func setupDisplayedCities() {
        let cities = favoriteLocations.map { city in
            city.name.trimmingCharacters(in: .whitespacesAndNewlines)
        }.filter { !$0.isEmpty && $0.lowercased() != "cairo" }
        
        withAnimation(.easeInOut) {
            self.displayedCities = cities
        }
    }
}

