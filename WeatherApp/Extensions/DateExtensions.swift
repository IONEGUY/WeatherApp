import Foundation

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    static func convertUnitTime(_ unixTime: Int64, withMinutes: Bool = false, dateFormat: String? = nil) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat ??
            (withMinutes ? Strings.hoursFormatWithMinutes : Strings.hoursFormat)
        return dateFormatter.string(from: date)
    }
    
    static func getCurrentDayName() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Strings.dayNameDateFormat
        return dateFormatter.string(from: date)
    }
}
