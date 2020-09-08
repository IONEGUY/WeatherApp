import Foundation

struct Rain: Codable {
    var precipiation: Float
    
    enum CodingKeys: String, CodingKey {
        case precipiation = "3h"
    }
}
