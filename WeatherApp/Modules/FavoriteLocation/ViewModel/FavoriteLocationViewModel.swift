
import Foundation

@Observable
@MainActor
class FavoriteLocationViewModel{
    var isMorning: Bool {
            let hour = Calendar.current.component(.hour, from: Date())
            return hour >= 5 && hour < 17
        }
            
        var backgroundVideoName: String {
            isMorning ? "morning" : "evening"
        }
}
