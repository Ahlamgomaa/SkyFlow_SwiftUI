
import Foundation

protocol WeatherRepository {
    func fetchCurrentWeather(for city: String) async throws -> CurrentWeatherResponse
    func searchCities(query: String) async throws -> [SearchResult]
}
