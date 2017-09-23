import Foundation

struct DetailsViewModel {
	let sunrise: String
	let sunset: String
	let humidity: String
	let visibility: String
	let wind: String
	let pressure: String

	init(forecast: CurrentWeatherResponse, timeZone: TimeZone) {
		let sunTimeFormatter = DateFormatter()
		sunTimeFormatter.setLocalizedDateFormatFromTemplate("h:mm a")
		sunTimeFormatter.timeZone = timeZone
		sunrise = sunTimeFormatter.string(from: forecast.location.sunrise!)
		sunset = sunTimeFormatter.string(from: forecast.location.sunset!)

		let humidityFormatter = NumberFormatter()
		humidityFormatter.maximumFractionDigits = 0
		humidityFormatter.numberStyle = .percent
		humidityFormatter.multiplier = 1.0
		humidity = humidityFormatter.string(from: forecast.weather.humidity as NSNumber)!

		let visibilityFormatter = MeasurementFormatter()
		let visibilityNumberFormatter = NumberFormatter()
		visibilityNumberFormatter.maximumFractionDigits = 0
		visibilityFormatter.numberFormatter = visibilityNumberFormatter
		visibilityFormatter.unitStyle = .medium
		visibility = visibilityFormatter.string(from: forecast.visibility)

		let pressureFormatter = MeasurementFormatter()
		let pressureNumberFormatter = NumberFormatter()
		pressureFormatter.numberFormatter = pressureNumberFormatter
		pressureNumberFormatter.maximumFractionDigits = 1
		pressureFormatter.unitStyle = .short
		pressure = "\(pressureFormatter.string(from: forecast.weather.pressure))"

		let windSpeedFormatter = MeasurementFormatter()
		let windSpeedNumberFormatter = NumberFormatter()
		windSpeedNumberFormatter.maximumFractionDigits = 0
		windSpeedFormatter.numberFormatter = windSpeedNumberFormatter
		windSpeedFormatter.unitStyle = .medium

		let windDirectionFormatter = MeasurementFormatter()
		windDirectionFormatter.unitStyle = .short

		let totalDegrees = forecast.wind.deg.converted(to: .degrees).value
		let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
		let index = Int((totalDegrees.truncatingRemainder(dividingBy: 360) / 45).truncatingRemainder(dividingBy: 8) + 0.5)

		let windSpeed = windSpeedFormatter.string(from: forecast.wind.speed)
		if index >= 0 && index <= directions.count-1 {
			wind = "\(windSpeed) \(directions[index])"
		} else {
			wind = windSpeed
		}

	}
}
