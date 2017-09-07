//
//  ScrollingViewController.swift
//  WeatherApp
//
//  Created by Leslie Perdue on 9/6/17.
//  Copyright © 2017 Corey Sprague. All rights reserved.
//

import UIKit

class ScrollingViewController: UIViewController, UIScrollViewDelegate
 {
	
	@IBOutlet weak var imageBlurOut: UIVisualEffectView!
	
	@IBOutlet weak var weatherScroll: UIScrollView!

	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	private var lastContentOffset: CGFloat = 0
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let opacity = max(scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.frame.height),0)
		
		imageBlurOut.alpha = min(opacity,1)
	}
}
