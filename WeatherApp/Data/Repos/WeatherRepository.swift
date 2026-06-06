
import Foundation

protocol WeatherRepository {
    func fetchForecast(lat: Double, lon: Double) async throws -> CurrentWeatherResponse
        func searchCities(query: String) async throws -> [SearchResult]
}
