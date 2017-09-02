import Foundation
import CoreLocation

class WeatherViewModel {
	var weatherService: WeatherService!
	let lastUpdatedFormatter = DateFormatter()
	let sunTimeFormatter = DateFormatter()
	
	init(weatherService: WeatherService) {
		self.weatherService = weatherService
		lastUpdatedFormatter.setLocalizedDateFormatFromTemplate("MMMM dd, h:mm a")
		sunTimeFormatter.setLocalizedDateFormatFromTemplate("h:mm a")
	}
	
	var FiveDayForecast: FiveDayForecastModel? = nil
	var location: String = ""
	var today: Today? = nil
	var hourlyForecast: [HourlyForecastViewModel] = [HourlyForecastViewModel]()
	var lastUpdated: String = ""
	lazy var geocoder = CLGeocoder()
	
	func search(searchString: String, completion: @escaping () -> Void){
		var forecast: CurrentForecast? = nil
		var reverseLocation: CLPlacemark? = nil
		let requestGroup =  DispatchGroup()
		requestGroup.enter()
		weatherService.getCurrentForecast(searchString: searchString, completion: { (currentForecast) in
			let location = CLLocation(latitude: currentForecast.lat, longitude: currentForecast.long)
			print("lat: \(currentForecast.lat), lon: \(currentForecast.long)")

			
			requestGroup.enter()
			self.geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
				for placemark in placemarks! {
					print("locality: \(placemark.locality ?? "<no locality>"), subLocality: \(placemark.subLocality ?? "<no sub-locality>"), country: \(placemark.country ?? "<no country>"), timezone: \(placemark.timeZone ?? NSTimeZone.default)")
					reverseLocation = placemark
				}
				requestGroup.leave()
			}

			forecast = currentForecast
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
			self.sunTimeFormatter.timeZone = reverseLocation?.timeZone
			self.lastUpdatedFormatter.timeZone = reverseLocation?.timeZone
			
			self.location = "\(forecast!.city), \(forecast!.country)"
			self.today = Today(
				temp: TemperatureViewModel(Int(forecast!.temperature), forecast!.unit),
				description: forecast!.weatherConditions.joined(separator: ", "),
				sunrise: self.sunTimeFormatter.string(from: forecast!.sunrise),
				sunset: self.sunTimeFormatter.string(from: forecast!.sunset)
			)
			self.lastUpdated = self.lastUpdatedFormatter.string(from: forecast!.lastUpdated)
			completion()
		})
	}
}

struct Today {
	let temp: TemperatureViewModel
	let description: String
	let sunrise: String
	let sunset: String
}

struct HourlyForecastViewModel {
	let temp: String
	let when: String
	let hourOfDayFormatter: DateFormatter = DateFormatter()
	
	init(_ temp: TemperatureViewModel, _ time: Date){
		hourOfDayFormatter.setLocalizedDateFormatFromTemplate("h a")
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
