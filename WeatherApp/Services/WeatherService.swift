import Foundation
import UIKit

class WeatherService {
    static var shared = WeatherService()
    
    func getWeather(weatherRequest: WeatherRequest,
                    completion: @escaping (Result<Weather, Error>) -> ()) {
        guard let request = createRequest(weatherRequest) else { return }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let weather = try JSONDecoder().decode(Weather.self, from: data)
                    completion(.success(weather))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    private func createRequest(_ weatherRequest: WeatherRequest) -> URLRequest? {
        guard var components = URLComponents(string: "\(ApiConstants.baseApiUrl)forecast")
            else { return nil }
        components.queryItems = [
            URLQueryItem(name: "lat", value: String(weatherRequest.latitude)),
            URLQueryItem(name: "lon", value: String(weatherRequest.longitude)),
            URLQueryItem(name: "appid", value: String(weatherRequest.appid)),
            URLQueryItem(name: "units", value: String(weatherRequest.units)),
        ]
        return URLRequest(url: components.url!)
    }
}
