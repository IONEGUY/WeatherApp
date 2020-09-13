import Foundation
 
class PlaceAutocompleteService: BaseApiService {
    func searchCities(query: String,
                      completion: @escaping (Result<CitiesSearchResponce, Error>) -> ()) {
        performFetchCall(withRequest: createRequest(query), completion)
    }
    
    private func createRequest(_ query: String) -> URLRequest? {
        guard var components = URLComponents(string: ApiConstants.placeAutocompleteUrl)
            else { return nil }
        
        components.queryItems = [
            URLQueryItem(name: "input", value: query),
            URLQueryItem(name: "key", value: ApiConstants.googleMapsApiKey),
            URLQueryItem(name: "language", value: ApiConstants.searchLang),
            URLQueryItem(name: "types", value: ApiConstants.searchType)
        ]
        
        guard let url = components.url else { return nil }
        return URLRequest(url: url)
    }
}
