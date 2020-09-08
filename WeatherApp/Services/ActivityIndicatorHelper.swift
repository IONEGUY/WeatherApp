import Foundation
import UIKit

class ActivityIndicatorHelper {
    private static var activityIndicator = UIActivityIndicatorView()
    
    static func show(_ view: UIView) {
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style =
            UIActivityIndicatorView.Style.large
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    static func hide() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}
