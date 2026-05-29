import SwiftUI

struct TopWeatherDivisionView: View {
    let weather: CurrentWeatherResponse
    let isMorning: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Text(weather.location.name)
                .font(.system(size: 34, weight: .bold ))
            
            Text("\(Int(weather.current.tempC))°")
                .font(.system(size: 96, weight: .thin))
            
            Text(weather.current.condition.text)
                .font(.system(size: 20, weight: .medium))
                .opacity(0.8)
            
            if let todayForecast = weather.forecast.forecastday.first {
                Text("H:\(Int(todayForecast.day.maxtempC))°     L:\(Int(todayForecast.day.mintempC))°")
                    .font(.system(size: 20, weight: .medium))
                    .opacity(0.9)
            }
            
            AsyncImage(url: URL(string: "https:\(weather.current.condition.icon)")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 80, height: 80)
        }
        .foregroundColor(isMorning ? .black : .white)
        .padding(.top, 50)
    }
}
