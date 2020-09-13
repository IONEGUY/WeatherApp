import Foundation
import UIKit

class ForecastTableViewController: UITableViewController, Initializable {
    private var viewModel: ForecastViewModel?
    private var forecast = [(key: String, value: [WeatherItem])]()
    private var errorHandler = AlertErrorMessageHandler()

    func initialize(withData data: Any) {
        guard let result = data as? Result<Weather, Error> else { return }
        let weatherModel: Weather?
        switch result {
            case .success(let success):
                weatherModel = success
            case .failure(let error):
                errorHandler.handle(error.localizedDescription)
                weatherModel = CashHelper.getValue(forKey: Strings.weatherKey)
        }
        self.viewModel = ForecastViewModel(weatherModel)
        self.createUI()
    }

    private func createUI() {
        forecast = viewModel?.forecast ?? [(key: String, value: [WeatherItem])]()
        
        tableView.reloadData()
    }
    
    private func createDayNameHeader(forSection section: Int) -> UIView {
        let container = UIView()
        let label = UILabel(frame: CGRect(x: 30, y: 0, width: view.frame.width - 30, height: 50))
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        container.backgroundColor = .separator
        container.heightAnchor.constraint(equalToConstant: 50).isActive = true
        let dayName = self.forecast[section].key
        label.text = section == 0 && dayName == Date.getCurrentDayName()
            ? Strings.today
            : dayName
        container.addSubview(label)
        return container
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cellType: WeatherTableViewCell.self)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createDayNameHeader(forSection: section)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return forecast.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        forecast[section].value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: WeatherTableViewCell.self, for: indexPath)
        let weatherItem = forecast[indexPath.section].value[indexPath.item]
        cell.initCell(weatherItem)
        return cell
    }
}
