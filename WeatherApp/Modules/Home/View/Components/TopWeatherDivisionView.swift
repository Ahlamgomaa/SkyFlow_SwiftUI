import SwiftUI

struct TopWeatherDivisionView: View {
    let weather: CurrentWeatherResponse
    let isMorning: Bool
    let isFavorite: Bool
    let onFavoriteTapped: () -> Void
    
    @State private var animateStar = false
    @State private var showDeleteAlert = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            AsyncImage(url: URL(string: "https:\(weather.current.condition.icon)")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Color.clear
            }
            .frame(width: 170, height: 170)
            .opacity(0.8)
            .offset(x: 15, y: -5)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            
            VStack(spacing: 4) {
                HStack(spacing: 10) {
                    Text(weather.location.name)
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
                    
                    Button(action: {
                        if isFavorite {
                            showDeleteAlert = true
                        } else {
                            triggerStarAnimation()
                            onFavoriteTapped()
                        }
                    }) {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                            .font(.title3)
                            .foregroundColor(isFavorite ? .red : .white)
                            .scaleEffect(animateStar ? 1.4 : 1.0)
                            .rotationEffect(.degrees(animateStar ? 15 : 0))
                    }
                    .animation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0), value: animateStar)
                }
                
                Text("\(Int(weather.current.tempC))°")
                    .font(.system(size: 86, weight: .thin, design: .rounded))
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .padding(.leading, 14)
                
                Text(weather.current.condition.text)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 1)
                
                if let todayForecast = weather.forecast.forecastday.first {
                    Text("H:\(Int(todayForecast.day.maxtempC))°  L:\(Int(todayForecast.day.mintempC))°")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 1)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .zIndex(1)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 10)

        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Remove from Favorites?"),
                message: Text("Are you sure you want to remove \(weather.location.name) from your favorite cities?"),
                primaryButton: .destructive(Text("Delete")) {
                    triggerStarAnimation()
                    onFavoriteTapped()
                },
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
    }
    
    private func triggerStarAnimation() {
        animateStar = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            animateStar = false
        }
    }
}
