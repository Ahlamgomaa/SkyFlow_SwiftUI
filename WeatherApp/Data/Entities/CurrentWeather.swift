import Foundation

public struct CurrentWeatherResponse: Decodable {
    public let location: LocationData
    public let current: CurrentWeatherData

}


public struct LocationData: Decodable {
    public let name: String
    public let region: String
    public let country: String
    public let lat: Double
    public let lon: Double
    public let tzId: String
    public let localtimeEpoch: Int
    public let localtime: String

    enum CodingKeys: String, CodingKey {
        case name, region, country, lat, lon
        case tzId = "tz_id"
        case localtimeEpoch = "localtime_epoch"
        case localtime
    }
}

public struct CurrentWeatherData: Decodable {
    public let lastUpdatedEpoch: Int
    public let lastUpdated: String
    public let tempC: Double
    public let tempF: Double
    public let isDay: Int
    public let condition: WeatherCondition
    public let windMph: Double
    public let windKph: Double
    public let pressureMb: Double
    public let humidity: Int
    public let feelslikeC: Double
    public let feelslikeF: Double
    public let visKm: Double
    public let uv: Double

    enum CodingKeys: String, CodingKey {
        case lastUpdatedEpoch = "last_updated_epoch"
        case lastUpdated = "last_updated"
        case tempC = "temp_c"
        case tempF = "temp_f"
        case isDay = "is_day"
        case condition
        case windMph = "wind_mph"
        case windKph = "wind_kph"
        case pressureMb = "pressure_mb"
        case humidity
        case feelslikeC = "feelslike_c"
        case feelslikeF = "feelslike_f"
        case visKm = "vis_km"
        case uv
    }
}

public struct WeatherCondition: Decodable {
    public let text: String
    public let icon: String
    public let code: Int
}
