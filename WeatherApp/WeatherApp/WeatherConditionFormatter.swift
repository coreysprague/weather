//
//  WeatherConditionFormatter.swift
//  WeatherApp
//
//  Created by Leslie Perdue on 9/11/17.
//  Copyright © 2017 Corey Sprague. All rights reserved.
//

import Foundation

class WeatherConditionFormatter {
	func string(from: WeatherCondition) -> String {
		let sun = "☀️"
		let snow = "🌨"
		let cloudy = "☁️"
		let rain = "🌧"
		let thunder = "🌩"
		let fog = "🌫"
		let tornado = "🌪"
		let hurricane = "🌀"
		let wind = "🌬"
		let cold = "❄️"
		let hot = "🔥"
		
		
		
		switch from.id {
		case 200..<300:
			return thunder
		case 300..<600:
			return rain
		case 600..<700:
			return snow
		case 700..<800:
			return fog
		case 800:
			return sun
		case 801..<900:
			return cloudy
		case 900:
			return tornado
		case 901,902:
			return hurricane
		case 903:
			return cold
		case 904:
			return hot
		case 905:
			return wind
		case 906:
			return rain
		default:
			return ""
		}
		
	}
}
