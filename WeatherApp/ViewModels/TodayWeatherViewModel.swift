import Foundation

class TodayWeatherViewModel {
    private var weather: Weather?
    
    var cityName: String?
    var weatherIconUrl: String?
    var temperature: String?
    var rainValue: String?
    var windValue: String?
    var precipiationValue: String?
    var directionValue: String?
    var pressureValue: String?
    var weatherSummary: String?
    
    init(_ weather: Weather?) {
        self.weather = weather
        
        initUIData()
    }
    
    private func initUIData() {
        guard let weather = weather,
              let weatherItem = weather.list.first,
              let weatherOverview = weatherItem.weatherOverview.first else { return }
        let cityInfo = weather.city
        
        weatherSummary = String(format: Strings.weatherDescriptionPattenr,
                                        weatherOverview.description,
                                        Int(weatherItem.weatherDetailedInfo.temp))
        weatherIconUrl = String(format: ApiConstants.iconsUrl, weatherOverview.icon)
        cityName = "\(cityInfo.name), \(cityInfo.country)"
        temperature = "\(Int(weatherItem.weatherDetailedInfo.temp))\(Strings.celsiusMarker) |" +
        " \(weatherOverview.description)"
        
        rainValue = "\(weatherItem.pop ?? 0 * 100)%"
        windValue = "\(weatherItem.wind?.speed ?? 0)km/h"
        precipiationValue = "\(weatherItem.rain?.precipiation ?? 0)mm"
        directionValue = Direction(Double(weatherItem.wind?.deg ?? 0)).description
        pressureValue = "\(weatherItem.weatherDetailedInfo.pressure)hPa"
    }
}
