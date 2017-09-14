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
		let adminArea = location?.administrativeArea ?? ""
		
		if(locationName == adminArea){
			city = locationName
		} else {
			city = "\(locationName), \(adminArea)"
		}
		country = location?.country ?? forecast.location.country
	}
}
