import Foundation

class WeatherViewModel {
	var weatherService: WeatherService!
	
	init(weatherService: WeatherService) {
		self.weatherService = weatherService
	}
	
	var FiveDayForecast: FiveDayForecastModel? = nil
	
	var location: String = ""
	var today: Today? = nil
	var hourlyForecast: [HourlyForecastViewModel] = [HourlyForecastViewModel]()
	
	func search(searchString: String, completion: @escaping () -> Void){
		let requestGroup =  DispatchGroup()
		requestGroup.enter()
		weatherService.getCurrentForecast(searchString: searchString, completion: { (currentForecast) in
			self.location = "\(currentForecast.city), \(currentForecast.country)"
			self.today = Today(
				temp: TemperatureViewModel(Int(currentForecast.temperature), currentForecast.unit),
				description: currentForecast.description
			)
			requestGroup.leave()
		})
		requestGroup.enter()
		weatherService.getFiveDayForecast(searchString: searchString, completion: { (fiveDayForecast) in
			var hourlyForecasts = [HourlyForecastViewModel]()
			for forecast in fiveDayForecast.forecast{
				let hourlyForecast = HourlyForecastViewModel(TemperatureViewModel(Int(forecast.temperature), "°F"), forecast.timeOfDay)
				hourlyForecasts.append(hourlyForecast)
			}
			self.hourlyForecast = hourlyForecasts
			requestGroup.leave()
		})
		requestGroup.notify(queue: DispatchQueue.main, execute: {
			completion()
		})
	}
}



//struct WeatherForecast {
//	let location: String
//	let temperature: TemperatureViewModel
//	let description: String
//}

struct Today {
	let temp: TemperatureViewModel
	let description: String
}

struct HourlyForecastViewModel {
	let temp: String
	let when: String
	let hourOfDayFormatter: DateFormatter = DateFormatter()
	
	init(_ temp: TemperatureViewModel, _ time: Date){
		hourOfDayFormatter.setLocalizedDateFormatFromTemplate("HH")
		self.temp = "\(temp.value)\(temp.unit)"
		self.when = hourOfDayFormatter.string(from: time)
	}
}

struct TemperatureViewModel {
	let unit: String
	let value: String
	
	init(_ value: Int, _ unit: String){
		self.unit = unit
		self.value = String(value)
	}
}
