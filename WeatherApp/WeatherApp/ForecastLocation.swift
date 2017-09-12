import Foundation
import CoreLocation

struct ForecastLocation {
	let location: CLLocation
	let id: Int
	let name: String
	let country: String
	let sunrise: Date?
	let sunset: Date?
}
