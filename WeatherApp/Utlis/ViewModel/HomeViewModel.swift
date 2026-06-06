import Foundation

@Observable
@MainActor
class HomeViewModel {
    
    private let repository: WeatherRepository
    
    var currentWeather: CurrentWeatherResponse?
    var isLoading = false
    var errorMessage: String?
    var isOffline = false
    
    var currentLatitude: Double = 30.5965
    var currentLongitude: Double = 32.2715

    init(repository: WeatherRepository = WeatherRepositoryImp()) {
        self.repository = repository
    }
    
    func loadWeatherData(lat: Double? = nil, lon: Double? = nil) {
        isLoading = true
        errorMessage = nil
        
        let targetLat = lat ?? currentLatitude
        let targetLon = lon ?? currentLongitude
        
        currentLatitude = targetLat
        currentLongitude = targetLon
        
        Task {
            do {
                let weatherData = try await repository.fetchForecast(lat: targetLat, lon: targetLon)
                self.currentWeather = weatherData
                self.isOffline = false
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                print("Error loading weather data: \(error)")
                
                if let urlError = error as? URLError,
                   urlError.code == .notConnectedToInternet || urlError.code == .timedOut {
                    self.isOffline = true
                } else {
                    self.isOffline = true
                }
            }
        }
    }
    
    var isMorning: Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        return hour >= 5 && hour < 17
    }
        
    var backgroundVideoName: String {
        isMorning ? "morning" : "evening"
    }
}
