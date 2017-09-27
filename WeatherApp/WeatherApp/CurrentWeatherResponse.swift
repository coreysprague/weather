import Foundation

struct CurrentWeatherResponse: Equatable {
	let location: ForecastLocation
	let conditions: [WeatherCondition]
	let weather: Weather
	let visibility: Measurement<UnitLength>
	let wind: Wind
	let lastUpdated: Date

	static func == (left: CurrentWeatherResponse, right: CurrentWeatherResponse) -> Bool {
		return
			left.location == right.location &&
			left.conditions == right.conditions &&
			left.weather == right.weather &&
			left.visibility == right.visibility &&
			left.wind == right.wind &&
			left.lastUpdated == right.lastUpdated
	}
}
