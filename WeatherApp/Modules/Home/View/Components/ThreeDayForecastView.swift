import SwiftUI

struct ThreeDayForecastView: View {
    let forecastDays: [ForecastDay]
    let isMorning: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "calendar")
                Text("3-DAY FORECAST")
                    .font(.system(size: 14, weight: .bold))
            }
            .foregroundColor(isMorning ? .black.opacity(0.6) : .white.opacity(0.6))
            .padding(.horizontal, 4)
            
            Divider()
                .background(isMorning ? Color.black.opacity(0.2) : Color.white.opacity(0.2))
            
            ForEach(Array(forecastDays.enumerated()), id: \.element.id) { index, dayData in
                HStack {
                    Text(getDayName(for: index, dateString: dayData.date))
                        .font(.system(size: 18, weight: .medium))
                        .frame(width: 110, alignment: .leading)
                    
                    Spacer()
                    
                    AsyncImage(url: URL(string: "https:\(dayData.day.condition.icon)")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 35, height: 35)
                    
                    Spacer()
                    
                    Text("\(Int(dayData.day.mintempC))° - \(Int(dayData.day.maxtempC))°")
                        .font(.system(size: 18, weight: .medium))
                        .frame(width: 90, alignment: .trailing)
                }
                .foregroundColor(isMorning ? .black : .white)
                .padding(.vertical, 4)
                
                if index < forecastDays.count - 1 {
                    Divider()
                        .background(isMorning ? Color.black.opacity(0.1) : Color.white.opacity(0.1))
                }
            }
        }
        .padding()
        .background(isMorning ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isMorning ? Color.white.opacity(0.3) : Color.black.opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal)
    }
    
    private func getDayName(for index: Int, dateString: String) -> String {
        if index == 0 { return "Today" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return dateString }
        
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
}
