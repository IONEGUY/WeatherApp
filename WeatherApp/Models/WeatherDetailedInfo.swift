import Foundation

struct WeatherDetailedInfo: Codable {
    var temp: Float
    var pressure: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case pressure
    }    
}
