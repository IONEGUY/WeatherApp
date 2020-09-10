import Foundation

struct WeatherItem: Codable, Hashable {
    static func == (lhs: WeatherItem, rhs: WeatherItem) -> Bool {
        return getDayComponent(lhs) == getDayComponent(rhs)
    }
    
    static private func getDayComponent(_ weatherItem: WeatherItem) -> Int? {
        return Date(timeIntervalSince1970: TimeInterval(weatherItem.dateTime)).get(.day).day
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(dateTime)
    }
    
    var dateTime: Int64
    var weatherDetailedInfo: WeatherDetailedInfo
    var weatherOverview: [WeatherOverview]
    var wind: Wind?
    var rain: Rain?
    var pop: Float?
    
    enum CodingKeys: String, CodingKey {
        case dateTime = "dt"
        case weatherDetailedInfo = "main"
        case weatherOverview = "weather"
        case wind
        case rain
        case pop
    }
}
