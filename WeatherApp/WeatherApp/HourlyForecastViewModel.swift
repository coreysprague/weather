import Foundation

struct HourlyForecastViewModel {
	let temperature: String
	let when: String
	let weather: String
	
	init(forecast: ForecastResponse, timeZone: TimeZone) {
		temperature = TemperatureFormatter().string(from: forecast.weather.temperature)
		
		let hourOfDayFormatter: DateFormatter = DateFormatter()
		hourOfDayFormatter.setLocalizedDateFormatFromTemplate("h a")
		hourOfDayFormatter.timeZone = timeZone
		when = hourOfDayFormatter.string(from: forecast.lastUpdated)
		
		if let primaryCondition = forecast.conditions.first {
			weather = WeatherConditionFormatter().string(from: primaryCondition)
		} else {
			weather = ""
		}
		
	}
}
