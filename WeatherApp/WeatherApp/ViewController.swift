//
//  ViewController.swift
//  WeatherApp
//
//  Created by Leslie Perdue on 7/21/17.
//  Copyright © 2017 Corey Sprague. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var currentForecast: CurrentForecast!
	
	private var weatherService: WeatherService = OpenWeatherMapService()
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func onSearch(_ sender: UIButton) {
		weatherService.getCurrentForecast(searchString: searchText.text!, completion: { [weak self](forecast: CurrentForecastViewModel) in
			self?.currentForecast.viewModel = forecast
		})
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

