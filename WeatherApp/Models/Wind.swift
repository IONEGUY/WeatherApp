import Foundation

struct Wind: Codable {
    var speed: Float
    var deg: Int
    
    enum CodingKeys: String, CodingKey {
        case speed
        case deg
    }    
}
