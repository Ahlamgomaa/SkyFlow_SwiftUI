

public struct ForecastData: Decodable {
    public let forecastday: [ForecastDay]
}

public struct ForecastDay: Decodable, Identifiable {
    public var id: String { date }
    public let date: String
    public let dateEpoch: Int
    public let day: DayInfo

    enum CodingKeys: String, CodingKey {
        case date
        case dateEpoch = "date_epoch"
        case day
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
