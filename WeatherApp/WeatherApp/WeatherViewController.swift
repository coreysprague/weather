import UIKit
import SideMenu

class WeatherViewController: UIViewController, UIScrollViewDelegate {

	@IBOutlet weak var searchText: UITextField!
	@IBOutlet weak var rightNow: RightNowView!
	@IBOutlet weak var hourlyForecast: UICollectionView!
	@IBOutlet weak var dailyForecast: UITableView!
	@IBOutlet weak var details: DetailedView!
	
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var backgroundBlur: UIVisualEffectView!
	@IBOutlet weak var backgroundImage: UIImageView!
	
	private var viewModel: WeatherViewModel = WeatherViewModel(weatherService: OpenWeatherMapService())
	private var hourlyForecastDataSource = HourlyForecastDataSource()
	private var dailyForecastDataSource = DailyForecastDataSource()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		viewModel.currentWeather.addListener(handler: updateWeather)
		viewModel.forecast.addListener(handler: updateForecast)
		viewModel.searchLocation.addListener(handler: updateSearchBar)
		hourlyForecast.dataSource = hourlyForecastDataSource
		dailyForecast.dataSource = dailyForecastDataSource
		dailyForecast.delegate = dailyForecastDataSource
		SideMenuManager.menuAnimationBackgroundColor = UIColor.clear
		SideMenuManager.menuPresentMode = .menuSlideIn
		SideMenuManager.menuAnimationFadeStrength = 0.2
		viewModel.load()
		print(view.frame.width)
		print(backgroundBlur.frame.origin)
		print(backgroundBlur.frame.width)
    }

	private func updateSearchBar(searchString: String?){
		searchText.text = searchString
	}
	
	@IBAction func onSearch(_ sender: UITextField) {
		//TODO: add basic validation
		//TODO: clear child view models
		
		UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseOut, animations: {
			self.backgroundImage.alpha = 0
			self.rightNow.alpha = 0
		}, completion: nil)
		
		viewModel.search(searchString: searchText.text!, onFailure: showError)
		sender.resignFirstResponder()
	}
	
	private func updateWeather(forecast: CurrentWeatherViewModel?){
		if (forecast == nil) {
			scrollView.setContentOffset(CGPoint(x: 0, y: -scrollView.contentInset.top), animated: true)
			scrollView.isScrollEnabled = false
			rightNow.viewModel = nil
			details.viewModel = nil
		} else {
			scrollView.isScrollEnabled = true
			rightNow.viewModel = forecast!.rightNow
			details.viewModel = forecast!.details
			backgroundImage.image = UIImage(named: forecast!.backgroundImageAsset)
		}
		
		UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseOut, animations: {
			self.backgroundImage.alpha = 1.0
			self.rightNow.alpha = 1.0
		}, completion: nil)
		
	}
	
	private func updateForecast(forecast: ForecastViewModel?){
		if(forecast != nil){
			hourlyForecastDataSource.hourlyForecasts = forecast!.hourlyForecast
			dailyForecastDataSource.dailyForecasts = forecast!.dailyForecast
		}
		hourlyForecast.reloadData()
		dailyForecast.reloadData()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		backgroundBlur.alpha = min(max(scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.frame.height),0),1)
	}
	
	func showError(error: Error) {
		let alert = UIAlertController(title: "Weather Unavailable", message: "Unable to load weather, please try again later", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in }))
		self.present(alert, animated: true, completion: nil)
	}
}

