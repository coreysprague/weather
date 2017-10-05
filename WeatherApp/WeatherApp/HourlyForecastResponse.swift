import Foundation

struct HourlyForecastResponse: Equatable {
	let conditions: [WeatherCondition]
	let weather: Weather
	let time: Date

	static func == (left: HourlyForecastResponse, right: HourlyForecastResponse) -> Bool {
		return
			left.conditions == right.conditions &&
			left.weather == right.weather &&
			left.time == right.time
	}
}
