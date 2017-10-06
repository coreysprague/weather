import Foundation
@testable import WeatherApp

class CurrentWeatherResponseBuilder {
	private var weatherConditions = [WeatherCondition]()
	private var lastUpdated = Date()
	private var temperature = Measurement<UnitTemperature>(value: 287.75, unit: .kelvin)
	private var location = ForecastLocation.Hillsboro

	func withConditions(_ weather: WeatherCondition...) -> CurrentWeatherResponseBuilder {
		weatherConditions.append(contentsOf: weather)
		return self
	}

	func withTemperature(_ degrees: Double, _ unit: UnitTemperature) -> CurrentWeatherResponseBuilder {
		temperature = Measurement<UnitTemperature>(value: degrees, unit: unit)
		return self
	}

	func withLastUpdatedTime(_ lastUpdated: Date) -> CurrentWeatherResponseBuilder {
		self.lastUpdated = lastUpdated
		return self
	}

	func withLocation(_ location: ForecastLocation) -> CurrentWeatherResponseBuilder {
		self.location = location
		return self
	}

	public func build() -> CurrentWeatherResponse {
		return CurrentWeatherResponse(
			location: self.location,
			conditions: weatherConditions,
			weather: Weather(
				temperature: self.temperature,
				pressure: Measurement<UnitPressure>(value: 1018, unit: .hectopascals),
				humidity: 82
			),
			visibility: Measurement<UnitLength>(value: 16093, unit: .meters),
			wind: Wind(
				speed: Measurement<UnitSpeed>(value: 1.5, unit: .metersPerSecond),
				deg: Measurement<UnitAngle>(value: 340, unit: .radians)
			),
			lastUpdated: self.lastUpdated
		)
	}
}
