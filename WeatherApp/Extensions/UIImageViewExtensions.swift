import Foundation
import UIKit

extension UIImageView {
    func initWith(url urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }                
            }
        }.resume()
    }
}
