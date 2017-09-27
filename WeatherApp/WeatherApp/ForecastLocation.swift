import Foundation
import CoreLocation

struct ForecastLocation: Equatable {
	let latitude: Double
	let longitude: Double
	let locationId: Int
	let name: String
	let country: String
	let sunrise: Date?
	let sunset: Date?

	static func == (left: ForecastLocation, right: ForecastLocation) -> Bool {
		return
			left.latitude  == right.latitude &&
			left.longitude == right.longitude &&
			left.locationId == right.locationId &&
			left.name == right.name &&
			left.country == right.country &&
			left.sunrise == right.sunrise &&
			left.sunset == right.sunset
	}
}
