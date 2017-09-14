import Foundation
import CoreLocation

class WeatherViewModel {
	private var weatherService: WeatherService
	private var locationProvider: LocationProvider
	private lazy var geocoder = CLGeocoder()

	let currentWeather = Observable<CurrentWeatherViewModel>()
	let hourlyForecast = Observable<[HourlyForecastViewModel]>()
	let dailyForecast = Observable<[DailyForecastViewModel]>()
	let searchLocation = Observable<String>()
	
	init(weatherService: WeatherService) {
		self.weatherService = weatherService
		locationProvider = LocationProvider()
		locationProvider.location.addListener(handler: updateSearchBarWithLocation)
	}
	
	func load(){
		searchLocation.value = ""
		currentWeather.value = nil
		locationProvider.locate()
	}
	
	private func updateSearchBarWithLocation(location: CLLocation?){
		if(location != nil) {
			self.geocoder.reverseGeocodeLocation(location!) { (placemarks, error) in
				if let reverseLocation = placemarks?.first {
					self.searchLocation.value = reverseLocation.locality
					self.weatherService.getWeatherByLocation(location: reverseLocation.location!, completion: self.displayWeather, failure: { (Error) in print("failed to load weather via GPS")})
				}
			}
		}
	}
	
	func search(searchString: String, onFailure: @escaping (Error) -> Void){
		let failure : (Error) -> Void = { (Error) in
			self.currentWeather.value = nil
			onFailure(Error)
		}
		if let zipCode = Int(searchString) {
			weatherService.getWeatherByZipcode(zipCode: zipCode, completion: displayWeather, failure: failure)
		} else {
			weatherService.getWeatherByCity(city: searchString, completion: displayWeather, failure: failure)
		}
	}
	
	private func displayWeather(forecastResponse: CurrentWeatherResponse) {
		self.geocoder.reverseGeocodeLocation(forecastResponse.location.location) { (placemarks, error) in
			if let reverseLocation = placemarks?.first {
				self.buildWeatherViewModel(currentForecast: forecastResponse, geoLocation: reverseLocation)
				
				self.weatherService.getHourlyForecastByCityId(
					cityId: forecastResponse.location.id,
					completion: { (forecastResponse) in
						self.displayHourlyForecast(forecast: forecastResponse, geoLocation: reverseLocation)
				})
				
				self.weatherService.getDailyForecastByCityId(
					cityId: forecastResponse.location.id,
					completion: { (forecastResponse) in
						self.displayDailyForecast(forecast: forecastResponse, geoLocation: reverseLocation)
				})
			}
		}
	}
	
	private func buildWeatherViewModel(currentForecast: CurrentWeatherResponse, geoLocation: CLPlacemark?) {
		let timeZone = geoLocation?.timeZone ?? TimeZone.current
		let rightNow = RightNowViewModel(forecast: currentForecast, timeZone: timeZone, location: geoLocation)
		let details = DetailsViewModel(forecast: currentForecast, timeZone: timeZone)
		let backgroundImage = ForecastBackgroundRetriever().getBackgroundImage(currentForecast: currentForecast, localTimeZone: timeZone)
		self.currentWeather.value = CurrentWeatherViewModel(rightNow: rightNow, details: details, backgroundImageAsset: backgroundImage)
	}
	
	private func displayHourlyForecast(forecast: [HourlyForecastResponse], geoLocation: CLPlacemark?) {
		let timeZone = geoLocation?.timeZone ?? TimeZone.current
		var hourlyForecasts = [HourlyForecastViewModel]()
		for hour in forecast {
			hourlyForecasts.append(HourlyForecastViewModel(forecast: hour, timeZone: timeZone))
		}
		self.hourlyForecast.value = hourlyForecasts
	}
	
	private func displayDailyForecast(forecast: [DailyForecastResponse], geoLocation: CLPlacemark?) {
		let timeZone = geoLocation?.timeZone ?? TimeZone.current
		var dailyForecasts = [DailyForecastViewModel]()
		for day in forecast {
			dailyForecasts.append(DailyForecastViewModel(forecast: day, timeZone: timeZone))
		}
		self.dailyForecast.value = dailyForecasts
	}
}
