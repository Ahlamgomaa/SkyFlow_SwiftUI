import Foundation
import SwiftData

@Model
final class FavoriteCity {
    @Attribute(.unique) var name: String
    var latitude: Double
    var longitude: Double    
    var timestamp: Date
    
    init(name: String, latitude: Double, longitude: Double, timestamp: Date = Date()) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
    }
}
