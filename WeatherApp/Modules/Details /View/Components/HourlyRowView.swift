
import SwiftUI
struct HourlyRowView: View {
    let hour: HourInfo
    
    var body: some View {
        HStack {
            Text(formatTime(hour.time))
                .font(.system(size: 26, weight: .regular))
                .frame(width: 120, alignment: .leading)
            
            Spacer()
            
            AsyncImage(url: URL(string: "https:\(hour.condition.icon)")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
                    .tint(.white)
            }
            .frame(width: 40, height: 40)
            
            Spacer()
            
            Text("\(Int(hour.tempC))°")
                .font(.system(size: 28, weight: .regular))
                .frame(width: 80, alignment: .trailing)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 30)
        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
    }
    
    private func formatTime(_ timeString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        guard let date = formatter.date(from: timeString) else { return timeString }
        formatter.dateFormat = "h a"
        return formatter.string(from: date)
    }
}
