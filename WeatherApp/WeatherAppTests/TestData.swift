import Foundation
import CoreLocation
@testable import WeatherApp

class TestData {
	let expectedWeatherResponse = CurrentWeatherResponse(
		location: ForecastLocation(
			latitude: 45.52,
			longitude: -122.99,
			locationId: 5731371,
			name: "Hillsboro",
			country: "US",
			sunrise: Date(timeIntervalSince1970: 1506175254),
			sunset: Date(timeIntervalSince1970: 1506218788)
		),
		conditions: [
			WeatherCondition(
				conditionId: 800,
				main: "Clear",
				description: "clear sky"
			)
		],
		weather: Weather(
			temperature: Measurement<UnitTemperature>(value: 287.75, unit: .kelvin),
			pressure: Measurement<UnitPressure>(value: 1018, unit: .hectopascals),
			humidity: 82
		),
		visibility: Measurement<UnitLength>(value: 16093, unit: .meters),
		wind: Wind(
			speed: Measurement<UnitSpeed>(value: 1.5, unit: .metersPerSecond),
			deg: Measurement<UnitAngle>(value: 340, unit: .radians)
		),
		lastUpdated: Date(timeIntervalSince1970: 1506138960)
	)

	let expectedHourlyForecast = [
		HourlyForecastResponse(
			conditions: [
				WeatherCondition(
					conditionId: 802,
					main: "Clouds",
					description: "scattered clouds"
				)
			],
			weather: Weather(
				temperature: Measurement<UnitTemperature>(value: 283.24, unit: .kelvin),
				pressure: Measurement<UnitPressure>(value: 1007.39, unit: .hectopascals),
				humidity: 88
			),
			time: Date(timeIntervalSince1970: 1506146400)
		),
		HourlyForecastResponse(
			conditions: [
				WeatherCondition(
					conditionId: 802,
					main: "Clouds",
					description: "scattered clouds"
				)
			],
			weather: Weather(
				temperature: Measurement<UnitTemperature>(value: 281.45, unit: .kelvin),
				pressure: Measurement<UnitPressure>(value: 1007.69, unit: .hectopascals),
				humidity: 88
			),
			time: Date(timeIntervalSince1970: 1506157200)
		)
	]

	let expectedDailyForecast = [
		DailyForecastResponse(
			conditions: [
				WeatherCondition(
					conditionId: 803,
					main: "Clouds",
					description: "broken clouds"
				)
			],
			highTemperature: Measurement<UnitTemperature>(value: 296.24, unit: .kelvin),
			lowTemperature: Measurement<UnitTemperature>(value: 282.17, unit: .kelvin),
			date: Date(timeIntervalSince1970: 1505332800)
		),
		DailyForecastResponse(
			conditions: [
				WeatherCondition(
					conditionId: 800,
					main: "Clear",
					description: "sky is clear"
				)
			],
			highTemperature: Measurement<UnitTemperature>(value: 293.91, unit: .kelvin),
			lowTemperature: Measurement<UnitTemperature>(value: 282.14, unit: .kelvin),
			date: Date(timeIntervalSince1970: 1505419200)
		)
	]
}
