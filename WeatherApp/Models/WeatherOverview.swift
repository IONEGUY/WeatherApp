import Foundation

struct WeatherOverview: Codable {
    var description: String
    var icon: String
    
    enum CodingKeys: String, CodingKey {
        case description
        case icon
    }
}
