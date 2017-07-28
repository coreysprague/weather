//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Leslie Perdue on 7/28/17.
//  Copyright © 2017 Corey Sprague. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol WeatherService {
	func getCurrentForecast(searchString: String, completion: @escaping (_ forecast: CurrentForecastViewModel) -> Void)
}

class OpenWeatherMapService: WeatherService {
	func getCurrentForecast(searchString: String, completion: @escaping (_ forecast: CurrentForecastViewModel) -> Void) {
		let url = "http://api.openweathermap.org/data/2.5/weather?q=\(searchString)&style=like&APPID=95d190a434083879a6398aafd54d9e73"
		Alamofire.request(url).responseJSON{ (responseData) -> Void in
			if((responseData.result.value) != nil) {
				let json = JSON(responseData.result.value!)
				let city = json["name"].string!
				let country = json["sys"]["country"].string!
				
				let temperature = (Int)(json["main"]["temp"].double! * (9/5) - 459.67)
				let forecastDescription = json["weather"][0]["description"].string!
				
				let forecast = CurrentForecastViewModel(location: "\(city), \(country)",
				                                        temperature: temperature,
				                                        unit: "°F",
				                                        description: forecastDescription)
				completion(forecast)
			}
		}
	}
}
