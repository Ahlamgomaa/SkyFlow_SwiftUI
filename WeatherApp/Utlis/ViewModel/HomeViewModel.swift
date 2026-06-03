import Foundation

@Observable
class HomeViewModel {
    
    private let repository: WeatherRepository
    
    var currentWeather: CurrentWeatherResponse?
    var isLoading = false
    var errorMessage: String?
    
    var searchResults: [SearchResult] = []
    var isSearching = false
    
    init(repository: WeatherRepository = WeatherRepositoryImp()) {
        self.repository = repository
    }
    
    func loadWeatherData(for city: String = "Cairo") {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let weatherData = try await repository.fetchCurrentWeather(for: city)
                self.currentWeather = weatherData
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                print("Error loading weather data: \(error)")
            }
        }
    }
    
    // الدالة الجديدة المحدثة والمنظمة لعمل السيرش اللحظي من الـ Repository
    func searchCities(query: String) {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.searchResults = []
            return
        }
        
        isSearching = true
        
        Task {
            do {
                let results = try await repository.searchCities(query: query)
                await MainActor.run {
                    self.searchResults = results
                    self.isSearching = false
                }
            } catch {
                print("Search ViewModel Error: \(error)")
                await MainActor.run {
                    self.isSearching = false
                }
            }
        }
    }
    
    var isMorning: Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour >= 5 && hour < 17 {
            return true
        } else {
            return false
        }
    }
        
    var backgroundVideoName: String {
        isMorning ? "morning" : "evening"
    }
}
