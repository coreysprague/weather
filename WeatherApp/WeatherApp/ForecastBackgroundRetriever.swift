import Foundation

class ForecastBackgroundRetriever {
	
	func getBackgroundImage(currentForecast: ForecastResponse, localTimeZone: TimeZone) -> String {
		
		let timeOfDay = getTimeOfDay(
			localTimeUtc: currentForecast.lastUpdated,
			sunriseUtc: currentForecast.location.sunrise!,
			sunsetUtc: currentForecast.location.sunset!,
			localTimezone: localTimeZone
		)
		
		var backgroundImage = "default_bg"
		if let primaryWeatherCondition = currentForecast.conditions.first {
			backgroundImage = getBackgroundImage(timeOfDay: timeOfDay, weatherCondition: primaryWeatherCondition)
		}
		
		return backgroundImage
	}
	
	private func getBackgroundImage(timeOfDay: String, weatherCondition: WeatherCondition) -> String{
		var categoryLookup : [String:String] = [
			"Thunderstorm" : "thunder", //2**
			"Drizzle" : "shower", //3**
			"Rain" : "rain", //5**
			"Snow" : "snow", //6**
			"Clear" : "clear", //8**
			"Clouds" : "scatteredclouds" //801 - 900
		]
		
		var codeSpecificLookup : [Int:String] = [
			801 : "fewclouds",
			802 : "scatteredclouds",
			803 : "brokenclouds"
		]
		
		if let imageCategory = codeSpecificLookup[weatherCondition.id]{
			return "\(imageCategory)_\(timeOfDay)"
		}
		else if let imageCategory = categoryLookup[weatherCondition.main] {
			return "\(imageCategory)_\(timeOfDay)"
		}
		else if weatherCondition.id >= 700 && weatherCondition.id < 800 {
			return "fog_\(timeOfDay)"
		}
		return "default_bg"
	}
	
	private func getTimeOfDay(localTimeUtc: Date, sunriseUtc: Date, sunsetUtc: Date, localTimezone: TimeZone) -> String {
		var calendar = Calendar.current
		calendar.timeZone = localTimezone
		
		let now = Date()
		let noon = calendar.date(
			bySettingHour: 12,
			minute: 0,
			second: 0,
			of: now)!
		
		if(localTimeUtc < sunriseUtc || localTimeUtc > sunsetUtc){
			return "night"
		} else if(localTimeUtc > sunriseUtc && localTimeUtc < noon){
			return "morning"
		} else {
			return "day"
		}
	}
}
