import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            VideoBackgroundView(videoName: viewModel.backgroundVideoName)
                .ignoresSafeArea()
            
            VStack {
                if viewModel.isLoading {
                    ProgressView("Fetching Weather...")
                        .scaleEffect(1.5)
                        .tint(.white)
                        .foregroundColor(.white)
                    
                } else if let weather = viewModel.currentWeather {
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 34) {
                            
                            VStack(spacing: 6) {
                                Text(weather.location.name)
                                    .font(.system(size: 34, weight: .regular))
                                    .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                                
                                Text("\(Int(weather.current.tempC))°")
                                    .font(.system(size: 88, weight: .thin))
                                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                                
                                Text(weather.current.condition.text)
                                    .font(.system(size: 22, weight: .medium))
                                    .opacity(0.9)
                                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                                
                                if let todayForecast = weather.forecast.forecastday.first {
                                    Text("H:\(Int(todayForecast.day.maxtempC))°  L:\(Int(todayForecast.day.mintempC))°")
                                        .font(.system(size: 20, weight: .medium))
                                        .opacity(0.9)
                                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                                }
                            }
                            .foregroundColor(.white)                             .padding(.top, 40)
                            
                            ThreeDayForecastView(forecastDays: weather.forecast.forecastday, isMorning: viewModel.isMorning)
                                .padding(.horizontal, 20)
                            
                            WeatherGridDetailsView(weather: weather, isMorning: viewModel.isMorning)
                                .padding(.horizontal, 4)
                                .padding(.bottom, 30)
                        }
                    }
                    
                } else if let error = viewModel.errorMessage {
                    ErrorStateView(message: error) {
                        viewModel.loadWeatherData()
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadWeatherData(for: "London")
        }
    }
}

