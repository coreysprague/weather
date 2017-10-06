import Foundation
import CoreLocation

struct RightNowViewModel {
	let temperature: String
	let weather: String
	let lastUpdated: String
	let city: String
	let country: String

	init(forecast: CurrentWeatherResponse, timeZone: TimeZone, location: CLPlacemark?) {
		temperature = TemperatureFormatter().string(from: forecast.weather.temperature)
		weather = forecast.conditions.first?.description ?? ""

		let lastUpdatedFormatter = DateFormatter()
		lastUpdatedFormatter.setLocalizedDateFormatFromTemplate("MMMM dd, h:mm a")
		lastUpdatedFormatter.timeZone = timeZone
		lastUpdated = lastUpdatedFormatter.string(from: forecast.lastUpdated)

		let locationName = location?.locality ?? forecast.location.name
		if let adminArea = location?.administrativeArea, adminArea != locationName {
			city = "\(locationName), \(adminArea)"
		} else {
			city = locationName
		}
		country = location?.country ?? forecast.location.country
	}
}
