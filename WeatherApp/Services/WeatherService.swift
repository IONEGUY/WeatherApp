import Foundation
import UIKit
import CoreLocation

class WeatherService: BaseApiService {
    func getWeather(forLocation location: CLLocationCoordinate2D,
                    completion: @escaping (Result<Weather, Error>) -> ()) {
        let request = createRequest(WeatherRequest(latitude: location.latitude, longitude: location.longitude))
        performFetchCall(withRequest: request, completion)
    }
    
    func getWeather(forCityName cityName: String,
                    completion: @escaping (Result<Weather, Error>) -> ()) {
        let request = createRequest(WeatherRequest(cityName: cityName))
        performFetchCall(withRequest: request, completion)
    }
    
    private func createRequest(_ weatherRequest: WeatherRequest) -> URLRequest? {
        guard var components = URLComponents(string: "\(ApiConstants.baseApiUrl)forecast")
            else { return nil }
        
        components.queryItems = [
            URLQueryItem(name: "q", value: weatherRequest.cityName ?? String.empty),
            URLQueryItem(name: "lat", value: String(weatherRequest.latitude ?? 0)),
            URLQueryItem(name: "lon", value: String(weatherRequest.longitude ?? 0)),
            URLQueryItem(name: "appid", value: String(weatherRequest.appid ?? ApiConstants.appId)),
            URLQueryItem(name: "units", value: String(weatherRequest.units ?? Strings.unit)),
        ]
        
        guard let url = components.url else { return nil }
        return URLRequest(url: url)
    }
}
