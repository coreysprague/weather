import Foundation

struct CurrentWeatherResponse {
	let location: ForecastLocation
	let conditions: [WeatherCondition]
	let weather: Weather
	let visibility: Measurement<UnitLength>
	let wind: Wind
	let lastUpdated: Date
}

struct DailyForecastResponse {
	let conditions: [WeatherCondition]
	let highTemperature: Measurement<UnitTemperature>
	let lowTemperature: Measurement<UnitTemperature>
	let date: Date
}

struct HourlyForecastResponse {
	let conditions: [WeatherCondition]
	let weather: Weather
	let time: Date
}
