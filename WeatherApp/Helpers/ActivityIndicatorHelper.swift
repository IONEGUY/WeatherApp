import Foundation
import UIKit

class ActivityIndicatorHelper {
    private static var container = UIView()

    class func show() {
        DispatchQueue.main.async {
            guard let rootView = UIApplication.shared.windows.first?.rootViewController?.view else { return }
                container.frame = rootView.frame
                container.center = rootView.center
                container.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
                
                let loadingView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
                loadingView.center = container.center
                loadingView.backgroundColor = .darkGray
                loadingView.clipsToBounds = true
                loadingView.layer.cornerRadius = 10
            
                let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0,
                                                                              width: 40.0, height: 40.0))
                activityIndicator.color = .white
                activityIndicator.style = UIActivityIndicatorView.Style.large
                activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2,
                                                   y: loadingView.frame.size.height / 2);

                loadingView.addSubview(activityIndicator)
                container.addSubview(loadingView)
                rootView.addSubview(container)
                activityIndicator.startAnimating()
        }
    }

    class func hide() {
        DispatchQueue.main.async {
            container.removeFromSuperview()
        }        
    }
}
