
import Foundation

public struct ForecastData: Decodable {
    public let forecastday: [ForecastDay]
}

public struct ForecastDay: Decodable {
    public let date: String
    public let dateEpoch: Int
    public let day: DayInfo
    public let hour: [HourInfo]

    enum CodingKeys: String, CodingKey {
        case date
        case dateEpoch = "date_epoch"
        case day
        case hour
    }
}

public struct DayInfo: Decodable {
    public let maxtempC: Double
    public let mintempC: Double
    public let condition: WeatherCondition

    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case mintempC = "mintemp_c"
        case condition
    }
}

public struct HourInfo: Decodable {
    public let time: String
    public let tempC: Double
    public let condition: WeatherCondition

    enum CodingKeys: String, CodingKey {
        case time
        case tempC = "temp_c"
        case condition
    }
}
