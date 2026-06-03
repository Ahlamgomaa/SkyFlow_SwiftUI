import Foundation
import Observation

@Observable
class AddCityViewModel {
    
    private let repository: WeatherRepository
    
    var searchResults: [SearchResult] = []
    var isSearching = false
    
    init(repository: WeatherRepository = WeatherRepositoryImp()) {
        self.repository = repository
    }
    
    func searchCities(query: String) {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.searchResults = []
            self.isSearching = false
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
}
