import Foundation

class ForecastViewModel {
    private var weather: Weather?
    
    var cityName: String?
    var forecast = [(key: String, value: [WeatherItem])]()
    
    init(_ weather: Weather?) {
        self.weather = weather
        
        createForecastCollection()
    }
    
    private func createForecastCollection() {
        guard let weather = weather else { return }
        self.cityName = weather.city.name

        let groups = Dictionary(grouping: weather.list, by: {
            Date.convertUnitTime($0.dateTime, dateFormat: Strings.dayNameDateFormat)
        })

        self.enumerateDays().forEach { (key) in
            guard let value = groups[key] else { return }
            self.forecast.append((key: key, value: value))
        }
    }
    
    private func enumerateDays() -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Strings.dayNameDateFormat
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dayOfWeek = calendar.component(.weekday, from: today) - 1
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        return (weekdays.lowerBound ..< weekdays.upperBound).compactMap {
            dateFormatter.string(from: calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today)!) }
    }
}
