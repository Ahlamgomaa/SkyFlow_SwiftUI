
import Foundation

protocol WeatherRepository {
    func fetchCurrentWeather(for city: String) async throws -> CurrentWeatherResponse
}
