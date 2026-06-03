import SwiftUI
import SwiftData

struct AddCityView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel = HomeViewModel()
    @Query private var favoriteCities: [FavoriteCity]
    
    @State private var searchText = ""
    @State private var pressedCityName: String? = nil
    
    let suggestedCities = [
        "Cairo", "Alexandria", "Washington", "New York",
        "Los Angeles", "Chicago", "Houston", 
        "Paris", "Tokyo", "Dubai", "Miami"
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
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("", text: $searchText, prompt: Text("Search for a city...").foregroundColor(.gray))
                        .foregroundColor(.white)
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
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                    
                    if viewModel.isSearching {
                        HStack {
                            Spacer()
                            ProgressView().tint(.white)
                            Spacer()
                        }
                        .padding(.top, 20)
                    }
                    
                    LazyVGrid(columns: columns, spacing: 0) {
                        if searchText.isEmpty {
                            ForEach(suggestedCities, id: \.self) { cityName in
                                let isAdded = favoriteCities.contains { $0.name.lowercased() == cityName.lowercased() }
                                
                                cityRowButton(name: cityName, country: "Suggested", isAdded: isAdded)
                            }
                        } else {
                            ForEach(viewModel.searchResults) { cityResult in
                                let isAdded = favoriteCities.contains { $0.name.lowercased() == cityResult.name.lowercased() }
                                
                                cityRowButton(name: cityResult.name, country: cityResult.country, isAdded: isAdded)
                            }
                        }
                    }
                }
            }
        }
        .background(
            Color(red: 10/255, green: 34/255, blue: 64/255)
                .ignoresSafeArea()
        )
        .navigationBarHidden(true)
    }
    
    @ViewBuilder
    private func cityRowButton(name: String, country: String, isAdded: Bool) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                pressedCityName = name
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                    pressedCityName = nil
                }
                toggleFavorite(cityName: name)
            }
        } label: {
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(name)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(1)
                        
                        Text(country)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    if isAdded {
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                            .font(.subheadline)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 24)
                
                Divider()
                    .background(Color.white.opacity(0.15))
            }
            .background(Color.white.opacity(pressedCityName == name ? 0.08 : 0.001))
        }
        .buttonStyle(.plain)
        .scaleEffect(pressedCityName == name ? 0.90 : 1.0)
    }
    
    private func toggleFavorite(cityName: String) {
        if let existingCity = favoriteCities.first(where: { $0.name.lowercased() == cityName.lowercased() }) {
            modelContext.delete(existingCity)
        } else {
            let newCity = FavoriteCity(name: cityName, timestamp: Date())
            modelContext.insert(newCity)
        }
        try? modelContext.save()
    }
}
