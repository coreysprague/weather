import Foundation

struct DailyForecastResponse {
	let conditions: [WeatherCondition]
	let highTemperature: Measurement<UnitTemperature>
	let lowTemperature: Measurement<UnitTemperature>
	let date: Date
}
