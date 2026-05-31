import Foundation

@Observable
class HomeViewModel {
    
    private let repository: WeatherRepository
    
    var currentWeather: CurrentWeatherResponse?
    var isLoading = false
    var errorMessage: String?
    
    init(repository: WeatherRepository = WeatherRepositoryImp()) {
        self.repository = repository
    }
    
    func loadWeatherData(for city: String = "London") {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let weatherData = try await repository.fetchCurrentWeather(for: city)
                self.currentWeather = weatherData
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                print("Error loading weather data: \(error)")
            }
        }
    }
    
    var isMorning: Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour >= 5 && hour < 18 {
            return true
        } else {
            return false
        }
    }
        
    var backgroundVideoName: String {
        isMorning ? "morning" : "evening"
    }
}
