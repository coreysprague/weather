import UIKit
import SideMenu

class WeatherViewController: UIViewController, UICollectionViewDataSource {

	@IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var currentForecast: CurrentForecastView!
	@IBOutlet weak var hourlyForecast: UICollectionView!
	
	private var viewModel: WeatherViewModel = WeatherViewModel(weatherService: OpenWeatherMapService())
	
    override func viewDidLoad() {
        super.viewDidLoad()
		SideMenuManager.menuAnimationBackgroundColor = UIColor.clear
		SideMenuManager.menuPresentMode = .menuSlideIn
		SideMenuManager.menuAnimationFadeStrength = 0.2
    }

    @IBAction func onSearch(_ sender: UIButton) {
		viewModel.search(searchString: searchText.text!, completion: { [weak self] in
			self?.currentForecast.viewModel = self?.viewModel
			self?.items = (self?.viewModel.hourlyForecast)!
			self?.hourlyForecast.reloadData()
		})
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	
	
	
	let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
	var items: [HourlyForecastViewModel] = [HourlyForecastViewModel]()

	
	
	// tell the collection view how many cells to make
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.items.count
	}
	
	// make a cell for each cell index path
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		// get a reference to our storyboard cell
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! HourlyForecastCell
		
		// Use the outlet in our custom class to get a reference to the UILabel in the cell
		cell.viewModel = self.items[indexPath.item]
		return cell
	}
}

