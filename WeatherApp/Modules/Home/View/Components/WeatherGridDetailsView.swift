import SwiftUI

struct WeatherGridDetailsView: View {
    let weather: CurrentWeatherResponse
    let isMorning: Bool
    
    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 24) {
            
            detailCard(title: "VISIBILITY", value: "\(Int(weather.current.visKm)) km")
            
            detailCard(title: "HUMIDITY", value: "\(weather.current.humidity)%")
            
            detailCard(title: "FEELS LIKE", value: "\(Int(weather.current.feelslikeC))°")
            
            detailCard(title: "PRESSURE", value: formatPressure(weather.current.pressureMb))
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }
    
    @ViewBuilder
    private func detailCard(title: String, value: String) -> some View {
        VStack(alignment: .center, spacing: 10) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white.opacity(0.8))
                .tracking(1)
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(red: 0/255, green: 85/255, blue: 160/255).opacity(0.5))
        .cornerRadius(12)
    }
    
    private func formatPressure(_ mb: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: mb)) ?? "\(Int(mb))"
    }
}
