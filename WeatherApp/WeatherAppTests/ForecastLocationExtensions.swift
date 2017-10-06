import Foundation
@testable import WeatherApp

extension ForecastLocation {
	public static var Hillsboro: ForecastLocation {
		return ForecastLocation(
			latitude: 45.52,
			longitude: -122.99,
			locationId: 5731371,
			name: "Hillsboro",
			country: "US",
			sunrise: Date(timeIntervalSince1970: 1506175254),
			sunset: Date(timeIntervalSince1970: 1506218788)
		)
	}
}
