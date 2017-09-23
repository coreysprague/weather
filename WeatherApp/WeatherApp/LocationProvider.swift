import Foundation
import CoreLocation

class LocationProvider: NSObject, CLLocationManagerDelegate {
	private let locationManager: CLLocationManager

	let location = Observable<CLLocation>()

	override init() {
		locationManager = CLLocationManager()
		super.init()
		locationManager.requestAlwaysAuthorization()
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
	}

	func locate() {
		locationManager.startUpdatingLocation()
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.first {
			self.location.value = location
			locationManager.stopUpdatingLocation()
		}
	}
}
