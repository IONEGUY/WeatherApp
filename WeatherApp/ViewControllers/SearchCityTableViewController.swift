import UIKit

class SearchCityTableViewController: UITableViewController, UISearchResultsUpdating {
    private var cities = [CitySearchPrediction]()
    private var placeAutocompleteService = PlaceAutocompleteService()
    private var errorHandler = AlertErrorMessageHandler()
    private var oldSearchText = String.empty
    
    var citySelected: ((String) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInsetAdjustmentBehavior = .never
    }

    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text,
               oldSearchText != text,
               !text.isEmptyOrWhitespace() {
            oldSearchText = text
            filterContentForSearchText(text)
        }
    }

    private func filterContentForSearchText(_ searchText: String) {
        placeAutocompleteService.searchCities(query: searchText) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let citiesSearchResponce):
                    self.cities = citiesSearchResponce.predictions
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    self.errorHandler.handle(error.localizedDescription)
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cityName = cities[indexPath.row].cityDescriptionFormatting?.mainText else { return }
        dismiss(animated: true, completion: nil)
        citySelected?(cityName)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: String.empty)
        let cityInfo = cities[indexPath.row]
        cell.textLabel?.text = cityInfo.cityDescriptionFormatting?.mainText
        cell.detailTextLabel?.text = cityInfo.description
        return cell
    }
}
