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
                        .tint(viewModel.isMorning ? .black : .white)
                        .foregroundColor(viewModel.isMorning ? .black : .white)
                    
                } else if let weather = viewModel.currentWeather {
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            TopWeatherDivisionView(weather: weather, isMorning: viewModel.isMorning)
                            
                            ThreeDayForecastView(forecastDays: weather.forecast.forecastday, isMorning: viewModel.isMorning)
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
