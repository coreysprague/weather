import UIKit
import SideMenu

class WeatherViewController: UIViewController, UIScrollViewDelegate {

	@IBOutlet weak var searchText: UITextField!
	@IBOutlet weak var currentForecast: RightNowView!
	@IBOutlet weak var hourlyForecast: UICollectionView!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var backgroundBlur: UIVisualEffectView!
	@IBOutlet weak var dailyForecast: UITableView!
	
	private var viewModel: WeatherViewModel = WeatherViewModel(weatherService: OpenWeatherMapService())
	private var hourlyForecastDataSource = HourlyForecastDataSource()
	private var dailyForecastDataSource = DailyForecastDataSource()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		hourlyForecast.dataSource = hourlyForecastDataSource
		dailyForecast.dataSource = dailyForecastDataSource
		dailyForecast.delegate = dailyForecastDataSource
		SideMenuManager.menuAnimationBackgroundColor = UIColor.clear
		SideMenuManager.menuPresentMode = .menuSlideIn
		SideMenuManager.menuAnimationFadeStrength = 0.2
    }

	@IBAction func onSearch(_ sender: UITextField) {
		viewModel.search(searchString: searchText.text!, completion: { [weak self] in
			self?.currentForecast.viewModel = self?.viewModel
			self?.hourlyForecastDataSource.hourlyForecasts = (self?.viewModel.hourlyForecast)!
			self?.dailyForecastDataSource.dailyForecasts = [1,2,3,4,5]
			self?.hourlyForecast.reloadData()
			self?.dailyForecast.reloadData()
		})
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let opacity = max(scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.frame.height),0)
		
		backgroundBlur.alpha = min(opacity,1)
	}
}

