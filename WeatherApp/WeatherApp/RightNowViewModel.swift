import Foundation
import CoreLocation

struct RightNowViewModel {
	let temperature: String
	let weather: String
	let lastUpdated: String
	let city: String
	let country: String
	
	init(forecast: ForecastResponse, timeZone: TimeZone, location: CLPlacemark?) {
		temperature = TemperatureFormatter().string(from: forecast.weather.temperature)
		weather = forecast.conditions.first?.description ?? ""
		
		let lastUpdatedFormatter = DateFormatter()
		lastUpdatedFormatter.setLocalizedDateFormatFromTemplate("MMMM dd, h:mm a")
		lastUpdatedFormatter.timeZone = timeZone
		lastUpdated = lastUpdatedFormatter.string(from: forecast.lastUpdated)
		
		city = "\(location?.locality ?? forecast.location.name), \(location?.administrativeArea ?? "")"
		country = location?.country ?? forecast.location.country
	}
}
