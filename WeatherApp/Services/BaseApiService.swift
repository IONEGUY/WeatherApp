import Foundation

class BaseApiService {
    func performFetchCall<T: Codable>(withRequest request: URLRequest?,
                                      _ completion: @escaping (Result<T, Error>) -> ()) {
        guard let request = request else { return }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let model = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(model))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
