import Foundation

class WeatherServicesImp: WeatherServices {
    
    static let shared = WeatherServicesImp()
    private init() {}
    
    private let apiKey = "c2d21e8337064c408d5152558262705"
    private let baseUrl = "https://api.weatherapi.com/v1/forecast.json"
    
    func getCurrentWeather(city: String) async throws -> CurrentWeatherResponse {
        guard var components = URLComponents(string: baseUrl) else {
            throw URLError(.badURL)
        }
        
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "days", value: "3"),
            URLQueryItem(name: "lang", value: "en"),
            URLQueryItem(name: "aqi", value: "no")
        ]
        
        components.percentEncodedQuery = components.query?.replacingOccurrences(of: "%2C", with: ",")
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let response = try JSONDecoder().decode(CurrentWeatherResponse.self, from: data)
        return response
    }
}
