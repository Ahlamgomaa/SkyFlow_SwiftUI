import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Bindable var homeViewModel: HomeViewModel
    @Environment(\.modelContext) private var modelContext
    @Query private var favoriteLocations: [FavoriteCity]
    
    @Query(sort: \FavoriteCity.timestamp, order: .forward) private var favoriteCities: [FavoriteCity]
    
    @State private var selectedCity: String? = nil
    @State private var showDetails = false
    
    @State private var showDeleteAlert = false
    @State private var cityToDelete: FavoriteCity? = nil
    
    var body: some View {
        ZStack {
            VideoBackgroundView(videoName: homeViewModel.backgroundVideoName)
                .ignoresSafeArea()
           
            VStack {
                if favoriteCities.isEmpty {
                    ContentUnavailableView("No Cities Saved", systemImage: "star.slash")
                        .foregroundColor(.red)
                } else {
                    List {
                        ForEach(favoriteCities) { city in
                            CustomFavoriteCityRow(city: city, repository: WeatherRepositoryImp()) {
                                handleCitySelection(city)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    cityToDelete = city
                                    showDeleteAlert = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            
            NavigationLink(
                isActive: $showDetails,
                destination: {
                    WeatherDetailsContentView(
                        viewModel: homeViewModel,
                        favoriteLocations: favoriteLocations,
                        modelContext: modelContext, cityName: <#String#>
                    )
                    .navigationBarBackButtonHidden(false)
                },
                label: { EmptyView() }
            )
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddCityView()) {
                    Image(systemName: "plus")
                        .font(.title3)
                        .foregroundColor(.white)
                }
            }
        }
        .alert("Delete City", isPresented: $showDeleteAlert, presenting: cityToDelete) { city in
            Button("Cancel", role: .cancel) { cityToDelete = nil }
            Button("Delete", role: .destructive) {
                confirmDelete(city)
            }
        } message: { city in
            Text("Are you sure you want to remove \(city.name) from your favorites?")
        }
    }
    
    private func handleCitySelection(_ city: FavoriteCity) {
        homeViewModel.loadWeatherData(lat: city.latitude, lon: city.longitude)
        showDetails = true
    }
    
    private func confirmDelete(_ city: FavoriteCity) {
        modelContext.delete(city)
        try? modelContext.save()
        cityToDelete = nil
    }
}

