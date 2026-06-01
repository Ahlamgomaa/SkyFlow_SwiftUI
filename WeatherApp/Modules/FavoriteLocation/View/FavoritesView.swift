import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Bindable var homeViewModel: HomeViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \FavoriteCity.timestamp, order: .forward) private var favoriteCities: [FavoriteCity]
    
    @State private var showNoInternetAlert = false
    @State private var isCheckingStatus = false
    
    var body: some View {
        ZStack {
            VideoBackgroundView(videoName: homeViewModel.backgroundVideoName)
                .ignoresSafeArea()
           
            
            VStack {
                if favoriteCities.isEmpty {
                    ContentUnavailableView("No Cities Saved", systemImage: "star.slash")
                        .foregroundColor(.red)
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
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
                                                    .font(.system(size: 14, weight: .regular))
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
                                    .foregroundColor( .white)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
            
            if isCheckingStatus && homeViewModel.isLoading {
                Color.black.opacity(0.15)
                    .ignoresSafeArea()
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)
            }
        }
    
        .onChange(of: homeViewModel.isLoading) { oldValue, newValue in
            if isCheckingStatus && !newValue {
                isCheckingStatus = false
                
                if homeViewModel.errorMessage != nil {
                    showNoInternetAlert = true
                } else {
                    dismiss()
                }
            }
        }
        .alert("No Internet Connection", isPresented: $showNoInternetAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("We couldn't fetch weather data. Please check your connection and try again.")
        }
    }
    
    private func handleCitySelection(_ cityName: String) {
        isCheckingStatus = true
        homeViewModel.loadWeatherData(for: cityName)
    }
}
