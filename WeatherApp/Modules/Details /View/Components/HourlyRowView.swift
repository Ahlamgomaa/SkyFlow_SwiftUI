import SwiftUI

struct HourlyRowView: View {
    let hour: HourInfo
    let isNow: Bool
    var body: some View {
        HStack(spacing: 0) {
            Text(isNow ? "Now" : formatTime(hour.time))
                .font(.system(size: 24, weight: isNow ? .bold : .medium))
                .foregroundColor(isNow ? .yellow : .white)
                .frame(width: 100, alignment: .leading)
            Spacer()
            AsyncImage(url: URL(string: "https:\(hour.condition.icon)")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
                    .tint(.white)
            }
            .frame(width: 65, height: 65)
            .frame(width: 80, alignment: .center)
            Spacer()
            Text("\(Int(hour.tempC))°")
                .font(.system(size: 28, weight: .medium, design: .rounded))
                .foregroundColor(.white)
                .frame(width: 70, alignment: .trailing)
        }
        .foregroundColor(.white)
        .frame(height: 65)
        .padding(.horizontal, 24)
    }
    
    private func formatTime(_ timeString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        guard let date = formatter.date(from: timeString) else { return timeString }
        formatter.dateFormat = "h a"
        return formatter.string(from: date)
    }
}
