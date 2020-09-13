import Foundation

struct CitiesSearchResponce: Codable {
    var predictions: [CitySearchPrediction]
    
    enum CodingKeys: String, CodingKey {
        case predictions
    }
}
