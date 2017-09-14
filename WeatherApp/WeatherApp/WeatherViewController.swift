import UIKit

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
		viewModel.currentWeather.addListener(handler: { [weak self] in self!.updateWeather }())
		viewModel.hourlyForecast.addListener(handler: { [weak self] in self!.updateHourlyForecast }())
		viewModel.dailyForecast.addListener(handler: { [weak self] in self!.updateDailyForecast }())
		viewModel.searchLocation.addListener(handler: { [weak self] in self!.updateSearchBar }())
		
		hourlyForecast.dataSource = hourlyForecastDataSource
		dailyForecast.dataSource = dailyForecastDataSource

		viewModel.load()
    }

	private func updateSearchBar(searchString: String?){
		searchText.text = searchString
	}
	
	@IBAction func onSearch(_ sender: UITextField) {
		guard let searchText = sender.text, !searchText.isEmpty else {
			return
		}
		
		UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseOut, animations: {
			self.backgroundImage.alpha = 0
			self.rightNow.alpha = 0
		}, completion: nil)
		
		viewModel.search(searchString: searchText, onFailure: showError)
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
	
	private func updateHourlyForecast(forecast: [HourlyForecastViewModel]?){
		hourlyForecastDataSource.hourlyForecasts = forecast ?? [HourlyForecastViewModel]()
		hourlyForecast.reloadData()
	}
	
	private func updateDailyForecast(forecast: [DailyForecastViewModel]?){
		dailyForecastDataSource.dailyForecasts = forecast ?? [DailyForecastViewModel]()
		dailyForecast.reloadData()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

