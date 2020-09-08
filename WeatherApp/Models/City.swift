import Foundation

struct City: Codable {
    var country: String
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case country
        case name
    }
}
