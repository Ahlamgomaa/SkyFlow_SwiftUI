import Foundation

class WeatherServicesImp: WeatherServices {
    
    static let shared = WeatherServicesImp()
    private init() {}
    
    private let apiKey = "c2d21e8337064c408d5152558262705"
    private let baseUrl = "https://api.weatherapi.com/v1/forecast.json"
    private let searchUrl = "https://api.weatherapi.com/v1/search.json"
    
    func getCurrentWeather(city: String) async throws -> CurrentWeatherResponse {
        let encodedCity = city.trimmingCharacters(in: .whitespacesAndNewlines)
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
            
        guard var components = URLComponents(string: baseUrl) else {
            throw URLError(.badURL)
        }
        
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: encodedCity),
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
    
    func searchCities(query: String) async throws -> [SearchResult] {
        guard let encodedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), !encodedQuery.isEmpty else {
            return []
        }
        
        guard var components = URLComponents(string: searchUrl) else {
            throw URLError(.badURL)
        }
        
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: encodedQuery)
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let response = try JSONDecoder().decode([SearchResult].self, from: data)
        return response
    }
}
