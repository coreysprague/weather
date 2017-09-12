import Foundation

struct Weather {
	let temperature: Measurement<UnitTemperature>
	let highTemperature: Measurement<UnitTemperature>
	let lowTemperature: Measurement<UnitTemperature>
	let pressure: Measurement<UnitPressure>
	let humidity: Double
}
