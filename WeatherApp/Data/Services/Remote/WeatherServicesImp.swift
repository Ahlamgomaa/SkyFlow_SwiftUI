import Foundation

class WeatherServicesImp: WeatherServices {
    
    private let networkClient: NetworkClient
        
        private let apiKey = "c2d21e8337064c408d5152558262705"
        private let baseURL = "https://api.weatherapi.com/v1"
        
        init(networkClient: NetworkClient = NetworkClientImp()) {
            self.networkClient = networkClient
        }
        
        func fetchForecast(lat: Double, lon: Double) async throws -> CurrentWeatherResponse {
            let urlString = "\(baseURL)/forecast.json?key=\(apiKey)&q=\(lat),\(lon)&days=3&lang=en&aqi=no&alerts=no"
            
            guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
            }
            
            return try await networkClient.fetch(url: url)
        }
        
        func searchCity(query: String) async throws -> [SearchResult] {
            let encodedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
            
            let urlString = "\(baseURL)/search.json?key=\(apiKey)&q=\(encodedQuery)"
            
            guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
            }
            
            return try await networkClient.fetch(url: url)
        }
    }

