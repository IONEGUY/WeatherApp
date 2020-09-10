import Foundation

class TodayWeatherViewModel {
    private var weather: Weather?
    private var weatherItem: WeatherItem!
    
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
        guard let weather = weather else { return }
        weatherItem = weather.list.first
        let cityInfo = weather.city
        
        weatherSummary = String(format: Strings.weatherDescriptionPattenr,
                                        weatherItem.weatherOverview.first!.description,
                                        Int(weatherItem.weatherDetailedInfo.temp))
        weatherIconUrl = String(format: ApiConstants.iconsUrl, weatherItem.weatherOverview.first!.icon)
        cityName = "\(cityInfo.name), \(cityInfo.country)"
        temperature = "\(Int(weatherItem.weatherDetailedInfo.temp))\(Strings.celsiusMarker) |" +
        " \(weatherItem.weatherOverview.first!.description)"
        
        rainValue = "\(weatherItem.pop ?? 0 * 100)%"
        windValue = "\(weatherItem.wind?.speed ?? 0)km/h"
        precipiationValue = "\(weatherItem.rain?.precipiation ?? 0)mm"
        directionValue = Direction(Double(weatherItem.wind?.deg ?? 0)).description
        pressureValue = "\(weatherItem.weatherDetailedInfo.pressure)hPa"
    }
}
