

import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
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
                                
                                TopWeatherDivisionView(weather: weather, isMorning: viewModel.isMorning)
                                
                                NavigationLink(destination: HourlyForecastView(viewModel: viewModel)) {
                                    ThreeDayForecastView(forecastDays: weather.forecast.forecastday, isMorning: viewModel.isMorning)
                                        .padding(.horizontal, 20)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
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
        }
        .onAppear {
            viewModel.loadWeatherData(for: "London")
        }
    }
}

