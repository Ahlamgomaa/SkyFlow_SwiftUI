import SwiftUI

struct WeatherGridDetailsView: View {
    let weather: CurrentWeatherResponse
    let isMorning: Bool
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            
            detailCard(title: "VISIBILITY", value: "\(Int(weather.current.visKm)) km", systemIcon: "eye.fill")
            
            detailCard(title: "HUMIDITY", value: "\(weather.current.humidity)%", systemIcon: "humidity.fill")
            
            detailCard(title: "FEELS LIKE", value: "\(Int(weather.current.feelslikeC))°", systemIcon: "thermometer.medium")
            
            detailCard(title: "PRESSURE", value: formatPressure(weather.current.pressureMb), systemIcon: "gauge.with.needle")
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func detailCard(title: String, value: String, systemIcon: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .tracking(1)

                Image(systemName: systemIcon)
                    .font(.footnote)
                    .foregroundColor(.white)
                
           
            }
            
            Text(value)
                .font(.system(size: 28, weight: .medium, design: .rounded))
                .foregroundColor(.white)
                .padding(.leading, 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.all, 16)
        .background(Color(red: 0/255, green: 85/255, blue: 160/255).opacity(0.45))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
    }
    
    private func formatPressure(_ mb: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: mb)) ?? "\(Int(mb))"
    }
}
