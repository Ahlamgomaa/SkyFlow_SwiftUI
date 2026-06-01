
import Foundation
import SwiftData

@Model
final class FavoriteCity {
    @Attribute(.unique) var name: String
    
    var timestamp: Date
    
    init(name: String, timestamp: Date = Date()) {
        self.name = name
        self.timestamp = timestamp
    }
}
