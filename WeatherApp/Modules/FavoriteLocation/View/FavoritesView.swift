import SwiftUI
import SwiftData

struct FavoritesView: View {
    @State private var viewModel = FavoriteLocationViewModel()
    
    @Environment(\.modelContext) private var modelContext
    @Query private var favoriteLocations: [FavoriteCity]
    @Query(sort: \FavoriteCity.timestamp, order: .forward) private var favoriteCities: [FavoriteCity]
    
    @State private var selectedCity: FavoriteCity? = nil
    @State private var showDetails = false
    
    @State private var showDeleteAlert = false
    @State private var cityToDelete: FavoriteCity? = nil
    
    var body: some View {
        ZStack {
            VideoBackgroundView(videoName: viewModel.backgroundVideoName)
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
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationDestination(isPresented: $showDetails) {
                if let selected = selectedCity {
                    SingleCityContainerView(
                        cityName: selected.name,
                        latitude: selected.latitude,
                        longitude: selected.longitude,
                        favoriteLocations: favoriteLocations,
                        modelContext: modelContext
                    )
                    .navigationBarBackButtonHidden(false)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddCityView()) {
                    Image(systemName: "plus")
                        .font(.title3)
                        .foregroundColor(viewModel.isMorning ? .black.opacity(0.9) : .white)
                }
            }
        }
        .alert("Delete City", isPresented: $showDeleteAlert, presenting: cityToDelete) { city in
            Button("Cancel", role: .cancel) { cityToDelete = nil }
            Button("Delete", role: .destructive) {
                confirmDelete(city)
            }
            Text("Are you sure you want to remove \(city.name) from your favorites?")
        }
    }
    
    private func handleCitySelection(_ city: FavoriteCity) {
        self.selectedCity = city
        showDetails = true
    }
    
    private func confirmDelete(_ city: FavoriteCity) {
        modelContext.delete(city)
        try? modelContext.save()
        cityToDelete = nil
    }
}
