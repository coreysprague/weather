import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation

protocol WeatherService {
	func getWeatherByCity(city: String, completion: @escaping (_ forecast: ForecastResponse) -> Void, failure: @escaping (Error) -> ())
	
	func getWeatherByLocation(location: CLLocation, completion: @escaping (_ forecast: ForecastResponse) -> Void, failure: @escaping (Error) -> ())
	
	func getWeatherByZipcode(zipCode: Int, completion: @escaping (_ forecast: ForecastResponse) -> Void, failure: @escaping (Error) -> ())
	
	func getWeatherByCityId(cityId: Int, completion: @escaping (_ forecast: ForecastResponse) -> Void, failure: @escaping (Error) -> ())
	
	func getForecastByCityId(cityId: Int, completion: @escaping (_ forecast: [ForecastResponse]) -> Void)
}

class OpenWeatherMapService: WeatherService {
	private let apiKey = "95d190a434083879a6398aafd54d9e73"
	private let weatherApi = "http://api.openweathermap.org/data/2.5/weather"
	private let forecastApi = "http://api.openweathermap.org/data/2.5/forecast"
	
	func getWeatherByCity(city: String, completion: @escaping (_ forecast: ForecastResponse) -> Void, failure: @escaping (Error) -> ()) {
		let queryParams = ["q": city]
		getWeather(queryParams: queryParams, completion: completion, failure: failure)
	}
	
	func getWeatherByLocation(location: CLLocation, completion: @escaping (_ forecast: ForecastResponse) -> Void, failure: @escaping (Error) -> ()) {
		let queryParams = [
			"lat": "\(location.coordinate.latitude)",
			"lon": "\(location.coordinate.longitude)"
		]
		getWeather(queryParams: queryParams, completion: completion, failure: failure)
	}
	
	func getWeatherByZipcode(zipCode: Int, completion: @escaping (_ forecast: ForecastResponse) -> Void, failure: @escaping (Error) -> ()) {
		let queryParams = ["zip": "\(zipCode)"]
		getWeather(queryParams: queryParams, completion: completion, failure: failure)
	}
	
	func getWeatherByCityId(cityId: Int, completion: @escaping (_ forecast: ForecastResponse) -> Void, failure: @escaping (Error) -> ()) {
		let queryParams = ["id": "\(cityId)"]
		getWeather(queryParams: queryParams, completion: completion, failure: failure)
	}
	
	private func getWeather(queryParams: [String:String], completion: @escaping (_ forecast: ForecastResponse) -> Void, failure: @escaping (Error) -> ()) {
		var params = queryParams
		params["APPID"] = apiKey
		Alamofire.request(weatherApi, parameters: params, encoding: URLEncoding.queryString)
					.validate()
					.responseJSON{ response in
						print(response.timeline)
						switch response.result {
							case .success(let value):
								let json = JSON(value)
								completion(self.getForecastResponse(json))
							case .failure(let error):
								print(error)
								failure(error)
							}
					}
	}
	
	func getForecastByCityId(cityId: Int, completion: @escaping ([ForecastResponse]) -> Void) {
		let queryParams = [
			"id": "\(cityId)",
			"APPID": apiKey
		]
		Alamofire.request(forecastApi, parameters: queryParams, encoding: URLEncoding.queryString)
					.validate()
					.responseJSON{ response in
						print(response.timeline)
						switch response.result {
						case .success(let value):
							let json = JSON(value)
							var forecasts = [ForecastResponse]()
							for (_,subJson):(String, JSON) in json["list"] {
								forecasts.append(self.getForecastResponse(subJson))
							}
							completion(forecasts)
						case .failure(let error):
							print(error)
						}
					}
	}
	
	private func getForecastResponse(_ json: JSON) -> ForecastResponse {
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
						highTemperature: Measurement(value: json["main"]["temp_max"].doubleValue, unit: UnitTemperature.kelvin),
						lowTemperature: Measurement(value: json["main"]["temp_min"].doubleValue, unit: UnitTemperature.kelvin),
						pressure: Measurement(value: json["main"]["pressure"].doubleValue, unit: UnitPressure.hectopascals),
						humidity: json["main"]["humidity"].doubleValue
		)
		
		let visibility = Measurement(value: json["visibility"].doubleValue, unit: UnitLength.meters)
		
		let wind = Wind(
						speed: Measurement(value: json["wind"]["speed"].doubleValue, unit: UnitSpeed.metersPerSecond),
						deg: Measurement(value: json["wind"]["deg"].doubleValue, unit: UnitAngle.radians)
		)
		
		let lastUpdated = Date(timeIntervalSince1970: json["dt"].doubleValue)
		
		return ForecastResponse(location: forecastLocation, conditions: weatherConditions, weather: weather, visibility: visibility, wind: wind, lastUpdated: lastUpdated)
		
	}
}
