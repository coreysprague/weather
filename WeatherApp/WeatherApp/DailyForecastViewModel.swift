import Foundation

struct DailyForecastViewModel {
	let dayOfWeek: String
	let weather: String
	let highTemp: String
	let lowTemp: String
	
	init(date: Date, timeZone: TimeZone, highTemp: Measurement<UnitTemperature>, lowTemp: Measurement<UnitTemperature>, condition: WeatherCondition){
		
		let dayOfWeekFormatter = DateFormatter()
		dayOfWeekFormatter.setLocalizedDateFormatFromTemplate("cccc")
		dayOfWeekFormatter.timeZone = timeZone
		dayOfWeek = dayOfWeekFormatter.string(from: date)
		
		weather = WeatherConditionFormatter().string(from: condition)
		
		let temperatureFormatter = TemperatureFormatter()
		self.highTemp = "\(temperatureFormatter.string(from: highTemp))⇡"
		self.lowTemp = "\(temperatureFormatter.string(from: lowTemp))⇣"
	}
}
