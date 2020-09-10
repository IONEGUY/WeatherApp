import Foundation
import MapKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var locationInitialized = false
    private var locationUpdatedCompletion: ((CLLocationCoordinate2D) -> ())?
    
    override init() {
        super.init()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func getCurrentLocation(completion: @escaping (CLLocationCoordinate2D) -> ()) {
        locationInitialized = false
        locationUpdatedCompletion = completion
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location?.coordinate else { return }
        if !locationInitialized {
            locationUpdatedCompletion?(location)
            locationInitialized = true
        }
    }
}
