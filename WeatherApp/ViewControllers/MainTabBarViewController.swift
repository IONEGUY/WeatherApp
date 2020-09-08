import UIKit
import MapKit
import CoreLocation

class MainTabBarViewController: UITabBarController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        initTabBarList()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        fetchWeather(location)
    }
    
    private func fetchWeather(_ location: CLLocationCoordinate2D) {
        ActivityIndicatorHelper.show(self.view)
        WeatherService.shared.getWeather(weatherRequest:
            WeatherRequest(latitude: location.latitude,
                           longitude: location.longitude,
                           appid: AppSecrets.appId,
                           units: Strings.unit)) { (result) in
            DispatchQueue.main.async {
                switch result {
                    case .success(let success):
                        CashHelper.weather = success
                    case .failure(_): break
                }

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
