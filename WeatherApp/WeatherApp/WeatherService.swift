//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Leslie Perdue on 7/28/17.
//  Copyright © 2017 Corey Sprague. All rights reserved.
//

import Foundation

protocol WeatherService {
	func getCurrentForecast(searchString: String) -> CurrentForecastViewModel
}

class OpenWeatherMapService: WeatherService {
	func getCurrentForecast(searchString: String) -> CurrentForecastViewModel {
		return CurrentForecastViewModel(location: "Seattle", temperature: 90, unit: "°C", description: "Damn Hot")
	}
}
