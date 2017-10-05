import Foundation

struct DailyForecastResponse: Equatable {
	let conditions: [WeatherCondition]
	let highTemperature: Measurement<UnitTemperature>
	let lowTemperature: Measurement<UnitTemperature>
	let date: Date

	static func == (left: DailyForecastResponse, right: DailyForecastResponse) -> Bool {
		return
			left.conditions == right.conditions &&
			left.highTemperature == right.highTemperature &&
			left.lowTemperature == right.lowTemperature &&
			left.date == right.date
	}
}
