import Foundation

class WeatherCellViewModel {
    private let weatherItem: WeatherItem
    
    var iconUrl: String
    var time: String
    var weatherDescription: String
    var temperature: String
    
    init(_ weatherItem: WeatherItem) {
        self.weatherItem = weatherItem
        
        iconUrl = String(format: ApiConstants.iconsUrl, weatherItem.weatherOverview.first?.icon ?? String.empty)
        weatherDescription = weatherItem.weatherOverview.first?.description ?? String.empty
        time = Date.convertUnitTime(weatherItem.dateTime, withMinutes: true)
        temperature = "\(Int(weatherItem.weatherDetailedInfo.temp))\(Strings.celsiusMarker)"
    }
}
