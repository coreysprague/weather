import Foundation

struct Weather: Equatable {
	let temperature: Measurement<UnitTemperature>
	let pressure: Measurement<UnitPressure>
	let humidity: Double

	static func == (left: Weather, right: Weather) -> Bool {
		return
			left.temperature == right.temperature &&
			left.pressure == right.pressure &&
			left.humidity == right.humidity
	}
}
