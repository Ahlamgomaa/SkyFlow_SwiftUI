import SwiftUI
struct CustomFavoriteCityRow: View {
    let city: FavoriteCity
    let repository: WeatherRepository
    let isMorning: Bool
    var onTap: () -> Void

    
    private var textColor:Color{
        isMorning ? .black.opacity(0.9) : .white
    }
    
    @State private var weather: CurrentWeatherResponse? = nil
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(city.name)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(textColor)
                }
                
                Spacer()
        
                if let weather = weather {
                    HStack(spacing: 12) {
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("\(Int(weather.current.tempC))°")
                                .font(.system(size: 32, weight: .medium))
                                .foregroundColor(textColor)

                            Text(weather.current.condition.text)
                                .font(.system(size: 14, weight: .bold))
                                .opacity(0.8)
                                .foregroundColor(textColor)

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
                        .tint(textColor)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .background(Color.white.opacity(0.15))
            .cornerRadius(15) 
            .foregroundColor(textColor)
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            Task {
                do {
                    let data = try await repository.fetchForecast(lat: city.latitude, lon: city.longitude)
                    self.weather = data
                } catch {
                    print("Failed to load weather data for \(city.name): \(error)")
                }
            }
        }
    }
}
