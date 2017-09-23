import Foundation
import CoreLocation

struct ForecastLocation {
	let location: CLLocation
	let locationId: Int
	let name: String
	let country: String
	let sunrise: Date?
	let sunset: Date?
}
