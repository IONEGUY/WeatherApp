import Foundation

struct CityDescriptionFormatting: Codable {
    var mainText: String?
    
    enum CodingKeys: String, CodingKey {
        case mainText = "main_text"
    }
}
