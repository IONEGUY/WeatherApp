import Foundation

struct Weather: Codable {
    var list: [WeatherItem]
    var city: City
    
    enum CodingKeys: String, CodingKey {
        case list
        case city
    }
}
