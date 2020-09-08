import Foundation

class CashHelper {
    private enum SettingsKeys: String {
        case weather
    }
    
    static var weather: Weather? {
        get {
            guard let savedData = UserDefaults.standard.object(forKey: SettingsKeys.weather.rawValue) as? Data,
            let decodedModel = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? Weather else { return nil }
            return decodedModel
        }
        set {
            let defaults = UserDefaults.standard
            let key = SettingsKeys.weather.rawValue
            
            if let model = newValue {
                if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: model, requiringSecureCoding: false) {
                    defaults.set(savedData, forKey: key)
                } else {
                    defaults.removeObject(forKey: key)
                }
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
}
