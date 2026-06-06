import SwiftUI

struct ThreeDayForecastView: View {
    let forecastDays: [ForecastDay]
    let isMorning: Bool
    let currentTemp: Double?
    let viewModel: HomeViewModel
    
    private var globalMinTemp: Double {
        forecastDays.map { $0.day.mintempC }.min() ?? 0
    }
    
    private var globalMaxTemp: Double {
        forecastDays.map { $0.day.maxtempC }.max() ?? 1
    }
    private var textColor : Color{
        isMorning ? .black.opacity(0.9) : .white
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .font(.footnote)
                    .foregroundColor(textColor)
                Text("3-DAY FORECAST")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(textColor)
            }
            .foregroundColor(.white.opacity(0.6))
           
            Divider()
                .background(Color.white.opacity(0.2))
            
            ForEach(Array(forecastDays.enumerated()), id: \.element.date) { index, dayData in
                let minTemp = dayData.day.mintempC
                let maxTemp = dayData.day.maxtempC
                NavigationLink(destination: HourlyForecastView(viewModel: viewModel, selectedDay: dayData, dayIndex: index)) {
                    HStack(spacing: 0) {
                        Text(getDayName(for: index, dateString: dayData.date))
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(textColor)
                            .frame(width: 85, alignment: .leading)
                        
                        AsyncImage(url: URL(string: "https:\(dayData.day.condition.icon)")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                                .tint(.white)
                        }
                        .frame(width: 32, height: 32)
                        .frame(width: 50, alignment: .center)
                        
                        Text("\(Int(minTemp))°")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(textColor)
                            .frame(width: 35, alignment: .leading)
                        
                        GeometryReader { geo in
                            let totalRange = globalMaxTemp - globalMinTemp == 0 ? 1 : globalMaxTemp - globalMinTemp
                            let startOffsetPercentage = (minTemp - globalMinTemp) / totalRange
                            let endOffsetPercentage = (maxTemp - globalMinTemp) / totalRange
                            
                            let barStartX = geo.size.width * CGFloat(startOffsetPercentage)
                            let barWidth = geo.size.width * CGFloat(endOffsetPercentage - startOffsetPercentage)
                            
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.black.opacity(0.25))
                                    .frame(height: 4)
                                
                                Capsule()
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: [Color.green.opacity(0.7), Color.orange.opacity(0.9)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ))
                                    .frame(width: max(barWidth, 4), height: 4)
                                    .offset(x: barStartX)
                                
                                if index == 0, let current = currentTemp {
                                    let currentPercentage = (current - globalMinTemp) / totalRange
                                    let dotX = (geo.size.width * CGFloat(currentPercentage)) - 3.5
                                    
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 7, height: 7)
                                        .shadow(color: .black.opacity(0.5), radius: 2)
                                        .offset(x: max(0, min(geo.size.width - 7, dotX)))
                                }
                            }
                            .frame(maxHeight: .infinity)
                        }
                        .frame(height: 20)
                        .padding(.horizontal, 10)
                        
                        Text("\(Int(maxTemp))°")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(textColor)
                            .frame(width: 35, alignment: .trailing)
                    }
                    .padding(.vertical, 4)
                    .contentShape(Rectangle())
                }
                .buttonStyle(InteractiveScaleButtonStyle())
                
                if index < forecastDays.count - 1 {
                    Divider()
                        .background(Color.white.opacity(0.15))
                }
            }
        }
        .padding(.all, 16)
        .background(Color(red: 0/255, green: 85/255, blue: 160/255).opacity(0.45))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
    }
    
    private func getDayName(for index: Int, dateString: String) -> String {
        if index == 0 { return "Today" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return dateString }
        
        formatter.dateFormat = "EEEE"
        let day = formatter.string(from: date)
        
        return day == "Wednesday" ? "Wed" : String(day.prefix(3))
    }
}

