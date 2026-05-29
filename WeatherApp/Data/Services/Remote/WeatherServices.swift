import Foundation

protocol WeatherServices {
    func getCurrentWeather(city: String) async throws -> CurrentWeatherResponse}
