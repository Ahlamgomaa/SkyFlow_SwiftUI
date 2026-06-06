import SwiftUI

struct HourlyForecastView: View {
    @Environment(\.dismiss) private var dismiss
    let viewModel: HomeViewModel
    let selectedDay: ForecastDay
    let dayIndex: Int
    private var filteredHours: [HourInfo] {
        let hours = selectedDay.hour
        
        if dayIndex == 0 {
            let currentHour = Calendar.current.component(.hour, from: Date())
            return hours.filter { hour in
                let hourComponent = hourHourComponent(from: hour.time)
                return hourComponent >= currentHour
            }
        } else {
            return hours
        }
    }
    
    var body: some View {
        ZStack {
            VideoBackgroundView(videoName: viewModel.backgroundVideoName)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(viewModel.isMorning ? .black.opacity(0.9) : .white)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        if !filteredHours.isEmpty {
                            ForEach(Array(filteredHours.enumerated()), id: \.element.time) { seqIndex, hour in
                                let isNowRow = (dayIndex == 0 && seqIndex == 0)
                                
                                HourlyRowView(hour: hour, isNow: isNowRow, isMorning: viewModel.isMorning)
                            }
                        } else {
                            ProgressView()
                                .tint(viewModel.isMorning ? .black.opacity(0.9) : .white)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func hourHourComponent(from timeString: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        if let date = formatter.date(from: timeString) {
            return Calendar.current.component(.hour, from: date)
        }
        return 0
    }
}
