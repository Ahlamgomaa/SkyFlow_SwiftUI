
class WeatherRepositoryImp: WeatherRepository {
    private let weatherService: WeatherServices
        
     
        init(weatherService: WeatherServices = WeatherServicesImp()) {
            self.weatherService = weatherService
        }
        
        func fetchForecast(lat: Double, lon: Double) async throws -> CurrentWeatherResponse {
            return try await weatherService.fetchForecast(lat: lat, lon: lon)
        }
        
        func searchCities(query: String) async throws -> [SearchResult] {
            return try await weatherService.searchCity(query: query)
        }
}
