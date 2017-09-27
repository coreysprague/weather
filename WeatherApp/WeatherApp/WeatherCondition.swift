import Foundation

struct WeatherCondition: Equatable {
	let conditionId: Int
	let main: String
	let description: String

	static func == (left: WeatherCondition, right: WeatherCondition) -> Bool {
		return
			left.conditionId == right.conditionId &&
			left.main == right.main &&
			left.description == right.description
	}
}
