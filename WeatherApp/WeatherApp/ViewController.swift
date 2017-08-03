//
//  ViewController.swift
//  WeatherApp
//
//  Created by Leslie Perdue on 7/21/17.
//  Copyright © 2017 Corey Sprague. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {

	@IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var currentForecast: CurrentForecast!
	@IBOutlet weak var hourlyForecast: UICollectionView!
	
	private var weatherService: WeatherService = OpenWeatherMapService()
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onSearch(_ sender: UIButton) {
		weatherService.getCurrentForecast(searchString: searchText.text!, completion: { [weak self](forecast: CurrentForecastViewModel) in
			self?.currentForecast.viewModel = forecast
		})
		weatherService.getFiveDayForecast(searchString: searchText.text!, completion: { [weak self](forecast: FiveDayForecastModel) in
			self?.items = (forecast.forecast)
			self?.hourlyForecast.reloadData()
		})
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	
	
	
	let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
	var items: [ForecastModel] = [ForecastModel]()

	
	
	// tell the collection view how many cells to make
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.items.count
	}
	
	// make a cell for each cell index path
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		// get a reference to our storyboard cell
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! HourlyForecast
		
		// Use the outlet in our custom class to get a reference to the UILabel in the cell
		cell.viewModel = self.items[indexPath.item]
		return cell
	}
}

