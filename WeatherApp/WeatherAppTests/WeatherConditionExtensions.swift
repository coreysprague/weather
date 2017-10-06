import Foundation
@testable import WeatherApp

extension WeatherCondition {
	public static var Clear: WeatherCondition {
		return WeatherCondition(
			conditionId: 800,
			main: "Clear",
			description: "clear sky"
		)
	}

	public static var Rainy: WeatherCondition {
		return WeatherCondition(
			conditionId: 500,
			main: "Rain",
			description: "light rain"
		)
	}
}
