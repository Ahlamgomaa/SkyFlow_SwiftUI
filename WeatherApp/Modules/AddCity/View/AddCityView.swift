import SwiftUI
import SwiftData

struct AddCityView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel = AddCityViewModel()
    @Query private var favoriteCities: [FavoriteCity]
    
    @State private var searchText = ""
    @State private var pressedCityName: String? = nil
    

    let suggestedCitiesWithCoordinates = [
        (name: "Alexandria", country: "Egypt", lat: 31.2001, lon: 29.9187),
        (name: "Washington", country: "United States", lat: 38.9072, lon: -77.0369),
        (name: "New York", country: "United States", lat: 40.7128, lon: -74.0060),
        (name: "Paris", country: "France", lat: 48.8566, lon: 2.3522),
        (name: "Tokyo", country: "Japan", lat: 35.6762, lon: 139.6503),
        (name: "Dubai", country: "United Arab Emirates", lat: 25.2048, lon: 55.2708),
        (name: "Miami", country: "United States", lat: 25.7617, lon: -80.1918),
        (name: "Los Angeles", country: "United States", lat: 34.0522, lon: -118.2437),
        (name: "Chicago", country: "United States", lat: 41.8781, lon: -87.6298),
        (name: "Houston", country: "United States", lat: 29.7604, lon: -95.3698)
    ]
    
    let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Button {
                    dismiss()
                }
                label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("", text: $searchText, prompt: Text("Search for a city..."))
                        .foregroundColor(.gray)
                        .autocorrectionDisabled()
                        .onChange(of: searchText) { _, newValue in
                            viewModel.searchCities(query: newValue)
                        }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color.white.opacity(0.12))
                .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .padding(.bottom, 20)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    if searchText.isEmpty {
                        Text("SUGGESTED CITIES")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                    
                    if viewModel.isSearching {
                        HStack {
                            Spacer()
                            ProgressView().tint(viewModel.isMorning ? .black.opacity(0.9) : .white)
                            Spacer()
                        }
                        .padding(.top, 20)
                    }
                    
                    LazyVGrid(columns: columns, spacing: 0) {
                        if searchText.isEmpty {
                            ForEach(suggestedCitiesWithCoordinates, id: \.name) { city in
                                let isAdded = favoriteCities.contains { $0.name.lowercased() == city.name.lowercased() }
                                
                                cityRowButton(name: city.name, country: city.country, isAdded: isAdded, lat: city.lat, lon: city.lon)
                            }
                        } else {
                            ForEach(viewModel.searchResults) { cityResult in
                                let isAdded = favoriteCities.contains { $0.name.lowercased() == cityResult.name.lowercased() }
                                
                                cityRowButton(name: cityResult.name, country: cityResult.country, isAdded: isAdded, lat: cityResult.lat, lon: cityResult.lon)
                            }
                        }
                    }
                }
            }
        }
        .background(
            ZStack {
                VideoBackgroundView(videoName: viewModel.backgroundVideoName)
                    .ignoresSafeArea()
                
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
            }
        )
        .navigationBarHidden(true)
    }
    
    @ViewBuilder
    private func cityRowButton(name: String, country: String, isAdded: Bool, lat: Double, lon: Double) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                pressedCityName = name
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                    pressedCityName = nil
                }
                toggleFavorite(cityName: name, lat: lat, lon: lon)
            }
        } label: {
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(name)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(viewModel.isMorning ? .black.opacity(0.9) : .white)
                            .lineLimit(1)
                        
                        Text(country)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    if isAdded {
                        Image(systemName: "star.fill")
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 24)
                
                Divider()
                    .background(Color.white.opacity(0.15))
            }
            .background(Color.white.opacity(pressedCityName == name ? 0.15 : 0.001))
        }
        .buttonStyle(.plain)
        .scaleEffect(pressedCityName == name ? 0.90 : 1.0)
    }
    
    private func toggleFavorite(cityName: String, lat: Double, lon: Double) {
        if let existingCity = favoriteCities.first(where: { $0.name.lowercased() == cityName.lowercased() }) {
            modelContext.delete(existingCity)
        } else {
            let newCity = FavoriteCity(name: cityName, latitude: lat, longitude: lon, timestamp: Date())
            modelContext.insert(newCity)
        }
        try? modelContext.save()
    }
}
