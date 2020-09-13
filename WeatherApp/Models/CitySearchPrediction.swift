import Foundation

struct CitySearchPrediction: Codable {
    var description: String?
    var cityDescriptionFormatting: CityDescriptionFormatting?
    
    enum CodingKeys: String, CodingKey {
        case description
        case cityDescriptionFormatting = "structured_formatting"
    }
}
