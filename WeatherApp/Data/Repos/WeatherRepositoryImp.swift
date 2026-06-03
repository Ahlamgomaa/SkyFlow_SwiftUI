
class WeatherRepositoryImp: WeatherRepository {
    
    private let weatherService: WeatherServices
    
    init(weatherService: WeatherServices = WeatherServicesImp.shared) {
        self.weatherService = weatherService
    }
    
    func fetchCurrentWeather(for city: String) async throws -> CurrentWeatherResponse {
        return try await weatherService.getCurrentWeather(city: city)
    }
    
    func searchCities(query: String) async throws -> [SearchResult] {
        return try await weatherService.searchCities(query: query)
    }
}
