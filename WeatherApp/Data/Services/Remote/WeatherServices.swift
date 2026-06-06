import Foundation

protocol WeatherServices {
    func fetchForecast(lat: Double, lon: Double) async throws -> CurrentWeatherResponse
        func searchCity(query: String) async throws -> [SearchResult]
}
