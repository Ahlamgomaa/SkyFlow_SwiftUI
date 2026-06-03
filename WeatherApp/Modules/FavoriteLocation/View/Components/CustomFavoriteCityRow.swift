import SwiftUI
struct CustomFavoriteCityRow: View {
    let city: FavoriteCity
    let repository: WeatherRepository
    var onTap: () -> Void
    
    @State private var weather: CurrentWeatherResponse? = nil
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(city.name)
                        .font(.system(size: 24, weight: .bold))
                }
                
                Spacer()
        
                if let weather = weather {
                    HStack(spacing: 12) {
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("\(Int(weather.current.tempC))°")
                                .font(.system(size: 32, weight: .medium))
                            Text(weather.current.condition.text)
                                .font(.system(size: 14, weight: .bold))
                                .opacity(0.8)
                        }
                        
                        AsyncImage(url: URL(string: "https:\(weather.current.condition.icon)")) { image in
                            image.resizable()
                                 .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 40, height: 40)
                    }
                } else {
                    ProgressView()
                        .tint(.white)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .background(Color.white.opacity(0.15))
            .cornerRadius(15) 
            .foregroundColor(.white)
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            Task {
                if let encoded = city.name.trimmingCharacters(in: .whitespacesAndNewlines).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    do {
                        let data = try await repository.fetchCurrentWeather(for: encoded)
                        self.weather = data
                    } catch {
                        print("Failed to load layout data for \(city.name): \(error)")
                    }
                }
            }
        }
    }
}
