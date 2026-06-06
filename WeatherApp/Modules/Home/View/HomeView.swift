import SwiftUI
import SwiftData
import CoreLocation

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var locationManager = LocationManager()
    
    @State private var hasLocationLoaded = false
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \FavoriteCity.timestamp, order: .forward)
    private var favoriteLocations: [FavoriteCity]
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                VideoBackgroundView(videoName: viewModel.backgroundVideoName)
                    .ignoresSafeArea()
                
                if viewModel.isOffline {
                    NoConnectionView(viewModel: viewModel)
                        .transition(.opacity.combined(with: .scale))
                } else {
                    if !hasLocationLoaded || locationManager.lastLocation == nil {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.white)
                    } else {
                        TabView {
                            SingleCityContainerView(
                                cityName: locationManager.locationString ?? "Ismailia",
                                latitude: locationManager.lastLocation?.coordinate.latitude ?? 30.5965,
                                longitude: locationManager.lastLocation?.coordinate.longitude ?? 32.2715,
                                favoriteLocations: favoriteLocations,
                                modelContext: modelContext
                            )
                            .id("current_location_page")
                            
                            ForEach(favoriteLocations) { city in
                                SingleCityContainerView(
                                    cityName: city.name,
                                    latitude: city.latitude,
                                    longitude: city.longitude,
                                    favoriteLocations: favoriteLocations,
                                    modelContext: modelContext
                                )
                                .id(city.persistentModelID)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .always))
                        .ignoresSafeArea(edges: .top)
                        .transition(.opacity)
                    }
                }
            }
            .animation(.easeInOut, value: viewModel.isOffline)
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
            locationManager.requestLocation()
            
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            
            UIPageControl.appearance().currentPageIndicatorTintColor = .white
            UIPageControl.appearance().pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.4)
        }
        .onChange(of: locationManager.lastLocation) { _, newLocation in
            if let newLocation {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        viewModel.loadWeatherData(
                            lat: newLocation.coordinate.latitude,
                            lon: newLocation.coordinate.longitude
                        )
                        self.hasLocationLoaded = true
                    }
                }
            }
        }
    }
}
