import SwiftUI

struct TopWeatherDivisionView: View {
    let weather: CurrentWeatherResponse
    let isMorning: Bool
    

    let isFavorite: Bool
    let onFavoriteTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 12) {
                Text(weather.location.name)
                    .font(.system(size: 34, weight: .regular))
                    .shadow(color: isMorning ? .white.opacity(0.3) : .black.opacity(0.3), radius: 4, x: 0, y: 2)
                
                Button(action: onFavoriteTapped) {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .font(.title2)
                        .foregroundColor(isFavorite ? .red : ( .white))
                }
            }
            
            Text("\(Int(weather.current.tempC))°")
                .font(.system(size: 88, weight: .thin))
                .shadow(color: isMorning ? .white.opacity(0.2) : .black.opacity(0.2), radius: 4, x: 0, y: 2)
            
            Text(weather.current.condition.text)
                .font(.system(size: 22, weight: .medium))
                .opacity(0.9)
                .shadow(color: isMorning ? .white.opacity(0.3) : .black.opacity(0.3), radius: 2, x: 0, y: 1)
            
            if let todayForecast = weather.forecast.forecastday.first {
                Text("H:\(Int(todayForecast.day.maxtempC))°  L:\(Int(todayForecast.day.mintempC))°")
                    .font(.system(size: 20, weight: .medium))
                    .opacity(0.9)
                    .shadow(color: isMorning ? .white.opacity(0.3) : .black.opacity(0.3), radius: 2, x: 0, y: 1)
            }
            
            AsyncImage(url: URL(string: "https:\(weather.current.condition.icon)")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
                    .tint(isMorning ? .black : .white)
            }
            .frame(width: 50, height: 50)
            
            Spacer()
        }
        .foregroundColor( .white)
        
    }
}
