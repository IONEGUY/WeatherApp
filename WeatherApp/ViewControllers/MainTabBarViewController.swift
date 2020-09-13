import UIKit
import CoreLocation
import MapKit

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    private let locationManager = LocationManager()
    private var cityName = String.empty
    private var searchController: UISearchController?
    private let weatherService = WeatherService()
    private let networkConnectionService = NetworkConnectionService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        
        updateWeather()
        trackNetworkConnection()
        updateTitle()
        configureSearchController()
        initTabBarList()
        initBarButtonItems()
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateTitle()
    }
    
    private func updateWeather() {
        if let weather: Weather? = CashHelper.getValue(forKey: Strings.weatherKey) {
            self.cityName = weather?.city.name ?? String.empty
            featchWeather(withCityName: self.cityName)
        } else {
            getCurrentLocation()
        }
    }
    
    @objc private func getCurrentLocation() {
        ActivityIndicatorHelper.show()
        locationManager.getCurrentLocation(completion: fetchWeather)
    }
    
    @objc private func getWeatherByCityName() {
        featchWeather(withCityName: self.cityName)
    }

    @objc private func openSearchPage() {
        guard let searchController = searchController else { return }
        present(searchController, animated: true, completion: nil)
    }
    
    private func initBarButtonItems() {
        navigationItem.leftBarButtonItem =
            createBarButtonItem("arrow.clockwise", #selector(getWeatherByCityName))
        navigationItem.rightBarButtonItems = [
            createBarButtonItem("location", #selector(getCurrentLocation)),
            createBarButtonItem("magnifyingglass", #selector(openSearchPage))]
    }

    private func trackNetworkConnection() {
        networkConnectionService.trackConnection { connected in
            DispatchQueue.main.async {
                if (connected) {
                    AlertDialogHelper.showToast(message: Strings.backOnlineMessage)
                    self.featchWeather(withCityName: self.cityName)
                } else {
                    AlertDialogHelper.showToast(message: Strings.noConnectionMessage)
                }
            }
        }
    }

    private func updateTitle() {
        switch selectedViewController {
        case is TodayWeatherViewController:
            title = Strings.today
        case is ForecastTableViewController:
            title = cityName
        default: break
        }
    }

    private func configureSearchController() {
        let citiesTableViewController = SearchCityTableViewController()
        citiesTableViewController.citySelected = featchWeather
        searchController = UISearchController(searchResultsController: citiesTableViewController)
        searchController?.searchResultsUpdater = citiesTableViewController
        searchController?.searchBar.placeholder = Strings.search
    }

    private func featchWeather(withCityName name: String) {
        ActivityIndicatorHelper.show()
        weatherService.getWeather(forCityName: name, completion: featchWeatherCompleted)
    }

    private func fetchWeather(withLocation location: CLLocationCoordinate2D) {
        ActivityIndicatorHelper.show()
        weatherService.getWeather(forLocation: location, completion: featchWeatherCompleted)
    }

    private func featchWeatherCompleted(_ result: Result<Weather, Error>) {
        DispatchQueue.main.async {
            switch result {
                case .success(let success):
                    self.cityName = success.city.name
                    CashHelper.setValue(forKey: Strings.weatherKey, value: success)
                    self.updateTitle()
                    
                case .failure(_): break
            }

            ActivityIndicatorHelper.hide()
            self.viewControllers?.forEach {
                ($0 as? Initializable)?.initialize(withData: result)
            }
        }
    }

    private func createBarButtonItem(_ imageName: String, _ action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(systemName: imageName),
                               style: .plain,
                               target: self,
                               action: action)
    }

    private func initTabBarList() {
        let todayWeatherViewController = TodayWeatherViewController()
        todayWeatherViewController.tabBarItem =
            UITabBarItem(title: Strings.today, image: UIImage(named: "sun"), tag: 0)

        let forecastViewController = ForecastTableViewController()
        forecastViewController.tabBarItem =
            UITabBarItem(title: Strings.forecast, image: UIImage(named: "forecast"), tag: 1)

        let tabBarList = [todayWeatherViewController, forecastViewController]
        viewControllers = tabBarList
    }
}
