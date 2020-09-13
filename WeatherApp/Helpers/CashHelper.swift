import Foundation

class CashHelper {
    class func setValue<T: Codable>(forKey key: String, value: T) {
        if let encoded = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    class func getValue<T: Codable>(forKey key: String) -> T? {
        guard let data = UserDefaults.standard.object(forKey: key) as? Data,
              let model = try? JSONDecoder().decode(T.self, from: data) else {
            return nil
        }
        
        return model
    }
}
