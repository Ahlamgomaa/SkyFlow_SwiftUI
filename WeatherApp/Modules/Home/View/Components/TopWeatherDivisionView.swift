import SwiftUI

struct TopWeatherDivisionView: View {
    let weather: CurrentWeatherResponse
    let isMorning: Bool
    let isFavorite: Bool
    let cityName: String
    let onFavoriteTapped: () -> Void
    
    @State private var animateStar = false
    @State private var showDeleteAlert = false
    private var textColor:Color{
        isMorning ? .black.opacity(0.9) : .white
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            AsyncImage(url: URL(string: "https:\(weather.current.condition.icon)")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure:
                    Image(systemName: "cloud.sun.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(textColor.opacity(0.6))
                case .empty:
                    ProgressView()
                        .tint(textColor)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 170, height: 170)
            .opacity(0.8)
            .offset(x: 15, y: -5)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            
            VStack(spacing: 4) {
                HStack(spacing: 10) {
                    Text(cityName.isEmpty ? weather.location.name : cityName)
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
                        .foregroundColor(textColor)
                    
                    Button(action: {
                        if isFavorite {
                            showDeleteAlert = true
                        } else {
                            triggerStarAnimation()
                            onFavoriteTapped()
                        }
                    }) {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                            .font(.title2)
                            .foregroundColor(isFavorite ? .red : textColor)
                            .scaleEffect(animateStar ? 1.3 : 1.0)
                    }
                }
                .padding(.leading, 14)
                
                Text(weather.current.condition.text)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 1)
                    .foregroundColor(textColor)
                
                if let todayForecast = weather.forecast.forecastday.first {
                    Text("H:\(Int(todayForecast.day.maxtempC))°  L:\(Int(todayForecast.day.mintempC))°")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 1)
                        .foregroundColor(textColor)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .zIndex(1)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 10)

        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Remove from Favorites?"),
                message: Text("Are you sure you want to remove \(cityName.isEmpty ? weather.location.name : cityName) from your favorite cities?"),
                primaryButton: .destructive(Text("Delete")) {
                    triggerStarAnimation()
                    onFavoriteTapped()
                },
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
    }
    
    private func triggerStarAnimation() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
            animateStar = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            animateStar = false
        }
    }
}
