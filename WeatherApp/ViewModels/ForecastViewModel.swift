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

        let days = self.enumerateDaysFromCurrent(daysCount: 5)
        days.forEach { (key) in
            guard let value = groups[key] else { return }
            self.forecast.append((key: key, value: value))
        }
    }
    
    private func enumerateDaysFromCurrent(daysCount: Int) -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Strings.dayNameDateFormat
        var days = [String]()
        for dayIndex in 0...daysCount {
            let day = Calendar.current.date(byAdding: .day, value: dayIndex, to: Date())
            days.append(dateFormatter.string(from: day!))
        }
        
        return days
    }
}
