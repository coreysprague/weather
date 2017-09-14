import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation

protocol WeatherService {
	func getWeatherByCity(city: String, completion: @escaping (_ forecast: CurrentWeatherResponse) -> Void, failure: @escaping (Error) -> ())
	
	func getWeatherByLocation(location: CLLocation, completion: @escaping (_ forecast: CurrentWeatherResponse) -> Void, failure: @escaping (Error) -> ())
	
	func getWeatherByZipcode(zipCode: Int, completion: @escaping (_ forecast: CurrentWeatherResponse) -> Void, failure: @escaping (Error) -> ())
	
	func getWeatherByCityId(cityId: Int, completion: @escaping (_ forecast: CurrentWeatherResponse) -> Void, failure: @escaping (Error) -> ())
	
	func getHourlyForecastByCityId(cityId: Int, completion: @escaping (_ forecast: [HourlyForecastResponse]) -> Void)
	
	func getDailyForecastByCityId(cityId: Int, completion: @escaping (_ forecast: [DailyForecastResponse]) -> Void)
}

class OpenWeatherMapService: WeatherService {
	private let apiKey = "95d190a434083879a6398aafd54d9e73"
	private let weatherApi = "http://api.openweathermap.org/data/2.5/weather"
	private let hourlyForecastApi = "http://api.openweathermap.org/data/2.5/forecast"
	private let dailyForecastApi = "http://api.openweathermap.org/data/2.5/forecast/daily"
	
	func getWeatherByCity(city: String, completion: @escaping (_ forecast: CurrentWeatherResponse) -> Void, failure: @escaping (Error) -> ()) {
		let queryParams = ["q": city]
		getWeather(queryParams: queryParams, completion: completion, failure: failure)
	}
	
	func getWeatherByLocation(location: CLLocation, completion: @escaping (_ forecast: CurrentWeatherResponse) -> Void, failure: @escaping (Error) -> ()) {
		let queryParams = [
			"lat": "\(location.coordinate.latitude)",
			"lon": "\(location.coordinate.longitude)"
		]
		getWeather(queryParams: queryParams, completion: completion, failure: failure)
	}
	
	func getWeatherByZipcode(zipCode: Int, completion: @escaping (_ forecast: CurrentWeatherResponse) -> Void, failure: @escaping (Error) -> ()) {
		let queryParams = ["zip": "\(zipCode)"]
		getWeather(queryParams: queryParams, completion: completion, failure: failure)
	}
	
	func getWeatherByCityId(cityId: Int, completion: @escaping (_ forecast: CurrentWeatherResponse) -> Void, failure: @escaping (Error) -> ()) {
		let queryParams = ["id": "\(cityId)"]
		getWeather(queryParams: queryParams, completion: completion, failure: failure)
	}
	
	private func getWeather(queryParams: [String:String], completion: @escaping (_ forecast: CurrentWeatherResponse) -> Void, failure: @escaping (Error) -> ()) {
		var params = queryParams
		params["APPID"] = apiKey
		Alamofire.request(weatherApi, parameters: params, encoding: URLEncoding.queryString)
					.validate()
					.responseJSON{ response in
						print(response.timeline)
						switch response.result {
							case .success(let value):
								let json = JSON(value)
								completion(self.getCurrentWeatherResponse(json))
							case .failure(let error):
								print(error)
								failure(error)
							}
					}
	}
	
	func getHourlyForecastByCityId(cityId: Int, completion: @escaping ([HourlyForecastResponse]) -> Void) {
		let queryParams = [
			"id": "\(cityId)",
			"APPID": apiKey
		]
		Alamofire.request(hourlyForecastApi, parameters: queryParams, encoding: URLEncoding.queryString)
			.validate()
			.responseJSON{ response in
				print(response.timeline)
				switch response.result {
				case .success(let value):
					let json = JSON(value)
					var forecasts = [HourlyForecastResponse]()
					for (_,subJson):(String, JSON) in json["list"] {
						forecasts.append(self.getHourlyForecastResponse(subJson))
					}
					completion(forecasts)
				case .failure(let error):
					print(error)
				}
		}
	}
	
	func getDailyForecastByCityId(cityId: Int, completion: @escaping ([DailyForecastResponse]) -> Void) {
		let queryParams = [
			"id": "\(cityId)",
			"APPID": apiKey
		]
		Alamofire.request(dailyForecastApi, parameters: queryParams, encoding: URLEncoding.queryString)
			.validate()
			.responseJSON{ response in
				print(response.timeline)
				switch response.result {
				case .success(let value):
					let json = JSON(value)
					var forecasts = [DailyForecastResponse]()
					for (_,subJson):(String, JSON) in json["list"] {
						forecasts.append(self.getDailyForecastResponse(subJson))
					}
					completion(forecasts)
				case .failure(let error):
					print(error)
				}
		}
	}
	
	private func getCurrentWeatherResponse(_ json: JSON) -> CurrentWeatherResponse {
		var sunrise : Date? = nil
		if let sunriseResponse = json["sys"]["sunrise"].double {
			sunrise = Date(timeIntervalSince1970: sunriseResponse)
		}
		
		var sunset : Date? = nil
		if let sunsetResponse = json["sys"]["sunset"].double {
			sunset = Date(timeIntervalSince1970: sunsetResponse)
		}
		
		let location = CLLocation(latitude: json["coord"]["lat"].doubleValue, longitude: json["coord"]["lon"].doubleValue)
		
		let forecastLocation = ForecastLocation(
							location: location,
							id: json["id"].intValue,
							name: json["name"].stringValue,
							country: json["sys"]["country"].stringValue,
							sunrise: sunrise,
							sunset: sunset
		)
		
		var weatherConditions = [WeatherCondition]()
		for (_, subJson) in json["weather"] {
			let weatherCondition = WeatherCondition(id: subJson["id"].intValue, main: subJson["main"].stringValue, description: subJson["description"].stringValue)
			weatherConditions.append(weatherCondition)
		}
		
		let weather = Weather(
						temperature: Measurement(value: json["main"]["temp"].doubleValue, unit: UnitTemperature.kelvin),
						pressure: Measurement(value: json["main"]["pressure"].doubleValue, unit: UnitPressure.hectopascals),
						humidity: json["main"]["humidity"].doubleValue
		)
		
		let visibility = Measurement(value: json["visibility"].doubleValue, unit: UnitLength.meters)
		
		let wind = Wind(
						speed: Measurement(value: json["wind"]["speed"].doubleValue, unit: UnitSpeed.metersPerSecond),
						deg: Measurement(value: json["wind"]["deg"].doubleValue, unit: UnitAngle.radians)
		)
		
		let lastUpdated = Date(timeIntervalSince1970: json["dt"].doubleValue)
		
		return CurrentWeatherResponse(location: forecastLocation, conditions: weatherConditions, weather: weather, visibility: visibility, wind: wind, lastUpdated: lastUpdated)
		
	}
	
	private func getHourlyForecastResponse(_ json: JSON) -> HourlyForecastResponse {
		var weatherConditions = [WeatherCondition]()
		for (_, subJson) in json["weather"] {
			let weatherCondition = WeatherCondition(id: subJson["id"].intValue, main: subJson["main"].stringValue, description: subJson["description"].stringValue)
			weatherConditions.append(weatherCondition)
		}
		
		let weather = Weather(
			temperature: Measurement(value: json["main"]["temp"].doubleValue, unit: UnitTemperature.kelvin),
			pressure: Measurement(value: json["main"]["pressure"].doubleValue, unit: UnitPressure.hectopascals),
			humidity: json["main"]["humidity"].doubleValue
		)
		
		let time = Date(timeIntervalSince1970: json["dt"].doubleValue)
		
		return HourlyForecastResponse(conditions: weatherConditions, weather: weather, time: time)
		
	}
	
	private func getDailyForecastResponse(_ json: JSON) -> DailyForecastResponse {
		var weatherConditions = [WeatherCondition]()
		for (_, subJson) in json["weather"] {
			let weatherCondition = WeatherCondition(id: subJson["id"].intValue, main: subJson["main"].stringValue, description: subJson["description"].stringValue)
			weatherConditions.append(weatherCondition)
		}
		
		let date = Date(timeIntervalSince1970: json["dt"].doubleValue)
		let high = Measurement(value: json["temp"]["max"].doubleValue, unit: UnitTemperature.kelvin)
		let low = Measurement(value: json["temp"]["min"].doubleValue, unit: UnitTemperature.kelvin)
		
		return DailyForecastResponse(conditions: weatherConditions, highTemperature: high, lowTemperature: low, date: date)
		
	}
	
}
