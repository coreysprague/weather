import Foundation
import Alamofire
import SwiftyJSON

struct ForecastModel {
	let temperature: Int
	let description: String
	let timeOfDay: Date
}

struct CurrentForecastModel {
	let city: String
	let country: String
	let temperature: Double
	let unit: String
	let description: String
}

struct FiveDayForecastModel {
	let forecast: [ForecastModel]
}

protocol WeatherService {
	func getCurrentForecast(searchString: String, completion: @escaping (_ forecast: CurrentForecastModel) -> Void)
	
	func getFiveDayForecast(searchString: String, completion: @escaping (_ forecast: FiveDayForecastModel) -> Void)
}

class OpenWeatherMapService: WeatherService {
	private let apiKey:String = "95d190a434083879a6398aafd54d9e73"
	
	func getCurrentForecast(searchString: String, completion: @escaping (_ forecast: CurrentForecastModel) -> Void) {
		let url = getRequestUrl(apiMethod: "weather", searchString: searchString)
		Alamofire.request(url).responseJSON{ (responseData) -> Void in
			if((responseData.result.value) != nil) {
				let json = JSON(responseData.result.value!)
				let temperature = (json["main"]["temp"].double! * (9/5) - 459.67)
				let forecast = CurrentForecastModel(city: json["name"].string!,
				                                    country: json["sys"]["country"].string!,
													temperature: temperature,
													unit: "°F",
													description: json["weather"][0]["description"].string!)
				completion(forecast)
			}
		}
	}
	
	func getFiveDayForecast(searchString: String, completion: @escaping (FiveDayForecastModel) -> Void) {
		let url = getRequestUrl(apiMethod: "forecast", searchString: searchString)
		Alamofire.request(url).responseJSON{ response in
			switch response.result {
			case .success(let value):
				let json = JSON(value)
				print(json)
				var forecasts = [ForecastModel]()
				for (_,subJson):(String, JSON) in json["list"] {
					let temperature = (Int)(subJson["main"]["temp"].double! * (9/5) - 459.67)
					let description = subJson["weather"][0]["main"].string!
					let time = Date(timeIntervalSince1970: subJson["dt"].doubleValue)
					forecasts.append(ForecastModel(temperature: temperature, description: description, timeOfDay: time))
				}
				let forecast = FiveDayForecastModel(forecast: forecasts)
				completion(forecast)
			case .failure(let error):
				print(error)
			}
		}
	}
	
	private func getRequestUrl(apiMethod: String, searchString: String) -> String{
		let encodedSearchString = searchString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
		return "http://api.openweathermap.org/data/2.5/\(apiMethod)?q=\(encodedSearchString ?? ""))&APPID=\(apiKey)"
	}
}
