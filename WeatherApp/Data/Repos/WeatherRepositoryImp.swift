
class WeatherRepositoryImp: WeatherRepository {
    
    private let weatherService: WeatherServices
    
    init(weatherService: WeatherServices = WeatherServicesImp.shared) {
        self.weatherService = weatherService
    }
    
    func fetchCurrentWeather(for city: String) async throws -> CurrentWeatherResponse {
        return try await weatherService.getCurrentWeather(city: city)
    }
}
