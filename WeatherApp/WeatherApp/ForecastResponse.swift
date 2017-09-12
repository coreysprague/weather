import Foundation

struct ForecastResponse {
	let location: ForecastLocation
	let conditions: [WeatherCondition]
	let weather: Weather
	let visibility: Measurement<UnitLength>
	let wind: Wind
	let lastUpdated: Date
}








