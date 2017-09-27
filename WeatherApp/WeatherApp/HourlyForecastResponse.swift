import Foundation

struct HourlyForecastResponse {
	let conditions: [WeatherCondition]
	let weather: Weather
	let time: Date
}
