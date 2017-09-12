import Foundation
import CoreLocation

class WeatherViewModel {
	private var weatherService: WeatherService
	private var locationProvider: LocationProvider
	private lazy var geocoder = CLGeocoder()

	let currentWeather = Observable<CurrentWeatherViewModel>()
	let forecast = Observable<ForecastViewModel>()
	let searchLocation = Observable<String>()
	
	init(weatherService: WeatherService) {
		self.weatherService = weatherService
		locationProvider = LocationProvider()
		locationProvider.location.addListener(handler: updateSearchBarWithLocation)
	}
	
	func load(){
		searchLocation.value = ""
		currentWeather.value = nil
		forecast.value = nil
		locationProvider.locate()
	}
	
	private func updateSearchBarWithLocation(location: CLLocation?){
		if(location != nil) {
			self.geocoder.reverseGeocodeLocation(location!) { (placemarks, error) in
				if let reverseLocation = placemarks?.first {
					self.searchLocation.value = reverseLocation.locality
					self.weatherService.getWeatherByLocation(location: (reverseLocation.location)!, completion: self.displayWeather, failure: { (Error) in })
				}
			}
		}
	}
	
	func search(searchString: String, onFailure: @escaping (Error) -> Void){
		let failureWrapper : (Error) -> Void = { (Error) in
			self.forecast.value = nil
			self.currentWeather.value = nil
			onFailure(Error)
		}
		
		weatherService.getWeatherByCity(city: searchString, completion: displayWeather, failure: failureWrapper)
	}
	
	private func displayWeather(forecastResponse: ForecastResponse) {
		self.geocoder.reverseGeocodeLocation(forecastResponse.location.location) { (placemarks, error) in
			if let reverseLocation = placemarks?.first {
				self.buildWeatherViewModel(currentForecast: forecastResponse, geoLocation: reverseLocation)
				self.weatherService.getForecastByCityId(
						cityId: forecastResponse.location.id,
						completion: { (fiveDayForecast) in
							self.buildForecastViewModel(fiveDayForecast: fiveDayForecast, geoLocation: reverseLocation)
				})
			}
		}
	}
	
	private func buildWeatherViewModel(currentForecast: ForecastResponse, geoLocation: CLPlacemark?) {
		let timeZone = geoLocation?.timeZone ?? TimeZone.current
		let rightNow = RightNowViewModel(forecast: currentForecast, timeZone: timeZone, location: geoLocation)
		let details = DetailsViewModel(forecast: currentForecast, timeZone: timeZone)
		let backgroundImage = ForecastBackgroundRetriever().getBackgroundImage(currentForecast: currentForecast, localTimeZone: timeZone)
		self.currentWeather.value = CurrentWeatherViewModel(rightNow: rightNow, details: details, backgroundImageAsset: backgroundImage)
	}
	
	///THIS WHOLE METHOD WAS SPIKED IN AND NEEDS TO BE REFACTORED - ITS A MESS
	private func buildForecastViewModel(fiveDayForecast: [ForecastResponse], geoLocation: CLPlacemark?) {
		let timeZone = geoLocation?.timeZone ?? TimeZone.current
		
		var hourlyForecasts = [HourlyForecastViewModel]()
		var dayForecasts = [DailyForecastViewModel]()
		
		let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
		
		var localizedDailyForecasts = [Int:[ForecastResponse]]()
		for forecast in fiveDayForecast {
			var components = calendar.dateComponents(in: timeZone, from: forecast.lastUpdated)
			if(components.weekday != nil){
				if(localizedDailyForecasts[components.weekday!] == nil){
					localizedDailyForecasts[components.weekday!] = [forecast]
				} else {
					localizedDailyForecasts[components.weekday!]!.append(forecast)
				}
			}
			hourlyForecasts.append(HourlyForecastViewModel(forecast: forecast, timeZone: timeZone))
		}
		
		let sortedDays = Array(localizedDailyForecasts.keys).sorted { (A, B) -> Bool in
			return A < B
		}
		for day in sortedDays {
			let forecasts = localizedDailyForecasts[day]
			var highTemp: Measurement<UnitTemperature>? = nil
			var lowTemp: Measurement<UnitTemperature>? = nil
			var date: Date? = nil
			var condition: WeatherCondition? = nil
			
			for forecast in forecasts! {
				if highTemp == nil || highTemp!.value < forecast.weather.highTemperature.value {
					highTemp = forecast.weather.highTemperature
				}
				if lowTemp == nil || lowTemp!.value > forecast.weather.lowTemperature.value {
					lowTemp = forecast.weather.lowTemperature
				}
				date = forecast.lastUpdated
				condition = forecast.conditions.first
			}
			dayForecasts.append(DailyForecastViewModel(date: date!, timeZone: timeZone, highTemp: highTemp!, lowTemp: lowTemp!, condition: condition!))
		}
		self.forecast.value = ForecastViewModel(hourlyForecast: hourlyForecasts, dailyForecast: dayForecasts)
	}
}
