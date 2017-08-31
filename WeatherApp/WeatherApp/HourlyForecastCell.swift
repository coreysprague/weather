//
//  FiveDayForecast.swift
//  WeatherApp
//
//  Created by Leslie Perdue on 7/28/17.
//  Copyright © 2017 Corey Sprague. All rights reserved.
//

import Foundation

import UIKit

@IBDesignable class HourlyForecastCell: UICollectionViewCell {
	var view: UIView!
	
	@IBOutlet weak var temperature: UILabel!
	@IBOutlet weak var hour: UILabel!
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	var viewModel : HourlyForecastViewModel? {
		get { return nil}
		set (forecast) {
			temperature.text = forecast?.temp
			hour.text = forecast?.when
		}
		
	}
	
	func setup() {
		view = loadViewFromNib()
		view.frame = bounds
		
		view.autoresizingMask = [UIViewAutoresizing.flexibleWidth,
		                         UIViewAutoresizing.flexibleHeight]
		
		addSubview(view)
	}
	
	func loadViewFromNib() -> UIView! {
		let bundle = Bundle(for: type(of: self))
		let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
		let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
		return view
	}
}
