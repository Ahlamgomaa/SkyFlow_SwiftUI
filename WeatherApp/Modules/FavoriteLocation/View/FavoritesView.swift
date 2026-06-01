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
                            Button {
                                handleCitySelection(city.name)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(city.name)
                                            .font(.system(size: 24, weight: .bold))
                                    }
                                    
                                    Spacer()
                            
                                    if let currentWeather = homeViewModel.currentWeather,
                                       currentWeather.location.name.lowercased() == city.name.lowercased() {
                                        VStack(alignment: .trailing, spacing: 2) {
                                            Text("\(Int(currentWeather.current.tempC))°")
                                                .font(.system(size: 32, weight: .medium))
                                            Text(currentWeather.current.condition.text)
                                                .font(.system(size: 14, weight: .bold))
                                                .opacity(0.8)
                                        }
                                    } else {
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 16, weight: .semibold))
                                            .opacity(0.7)
                                    }
                                }
                                .padding(.horizontal, 24)
                                .padding(.vertical, 20)
                                .background(Color.white.opacity(0.15))
                                .cornerRadius(15)
                                .foregroundColor(.white)
                            }
                            .buttonStyle(PlainButtonStyle())
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
                        modelContext: modelContext
                    )
                    .navigationBarBackButtonHidden(false)
                },
                label: { EmptyView() }
            )
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    print("Navigate to Add City Screen")
                } label: {
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
    
    private func handleCitySelection(_ cityName: String) {
        homeViewModel.loadWeatherData(for: cityName)
        showDetails = true
    }
    
    private func confirmDelete(_ city: FavoriteCity) {
        modelContext.delete(city)
        try? modelContext.save()
        cityToDelete = nil
    }
}
