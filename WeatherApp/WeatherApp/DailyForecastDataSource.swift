import UIKit

class DailyForecastDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
	
	let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
	private var items: [DailyForecastViewModel] = [DailyForecastViewModel]()
	
	var dailyForecasts: [DailyForecastViewModel] {
		get {
			return items
		}
		set (forecast){
			items = forecast
		}
	}
	
	// tell the collection view how many cells to make
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.items.count
	}
	
	// make a cell for each cell index path
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		// get a reference to our storyboard cell
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! DailyForecastCell
		
		cell.layer.backgroundColor = UIColor.clear.cgColor
		cell.contentView.backgroundColor = UIColor.clear
		
		// Use the outlet in our custom class to get a reference to the UILabel in the cell
		cell.viewModel = self.items[indexPath.item]
		return cell
	}
}
