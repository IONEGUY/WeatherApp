import UIKit
import CoreLocation

class MainTabBarViewController: UITabBarController {
    private let locationManager = LocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        initTabBarList()
        locationManager.getCurrentLocation(completion: fetchWeather)
    }

    private func fetchWeather(_ location: CLLocationCoordinate2D) {
        ActivityIndicatorHelper.show(self.view)
        WeatherService.shared.getWeather(weatherRequest:
            WeatherRequest(latitude: location.latitude,
                           longitude: location.longitude,
                           appid: ApiConstants.appId,
                           units: Strings.unit)) { (result) in
            DispatchQueue.main.async {
                switch result {
                    case .success(let success):
                        CashHelper.weather = success
                    case .failure(_): break
                }

                ActivityIndicatorHelper.hide()
                self.viewControllers?.forEach {
                    ($0.children.first as? Initializable)?.initialize(withData: result)
                }
            }
        }
    }

    private func initTabBarList() {
        let todayWeatherViewController =
            UINavigationController(rootViewController: TodayWeatherViewController())
        todayWeatherViewController.tabBarItem = UITabBarItem(title: Strings.today,
                                                             image: UIImage(named: "sun"),
                                                             tag: 0)
        let forecastViewController =
            UINavigationController(rootViewController: ForecastTableViewController())
        forecastViewController.tabBarItem = UITabBarItem(title: Strings.forecast,
                                                         image: UIImage(named: "forecast"),
                                                         tag: 1)
        let tabBarList = [todayWeatherViewController, forecastViewController]
        viewControllers = tabBarList
    }
}
