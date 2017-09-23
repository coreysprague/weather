import Foundation

struct DailyForecastViewModel {
	let dayOfWeek: String
	let weather: String
	let highTemp: String
	let lowTemp: String

	init(forecast: DailyForecastResponse, timeZone: TimeZone) {

		let dayOfWeekFormatter = DateFormatter()
		dayOfWeekFormatter.setLocalizedDateFormatFromTemplate("cccc")
		dayOfWeekFormatter.timeZone = timeZone
		dayOfWeek = dayOfWeekFormatter.string(from: forecast.date)

		if let condition = forecast.conditions.first {
			weather = WeatherConditionFormatter().string(from: condition)
		} else {
			weather = ""
		}

		let temperatureFormatter = TemperatureFormatter()
		self.highTemp = "\(temperatureFormatter.string(from: forecast.highTemperature))⇡"
		self.lowTemp = "\(temperatureFormatter.string(from: forecast.lowTemperature))⇣"
	}
}
