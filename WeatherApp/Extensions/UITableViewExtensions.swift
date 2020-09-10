import Foundation
import UIKit

extension UITableView {
    func register<T: UITableViewCell>(cellType: T.Type, bundle: Bundle? = nil) {
        let className = cellType.typeName
        register(cellType, forCellReuseIdentifier: className)
    }

    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: type.typeName, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with type \(type.typeName)")
        }
        
        return cell
    }
}
