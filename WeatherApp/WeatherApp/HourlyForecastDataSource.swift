import UIKit

class HourlyForecastDataSource: NSObject, UICollectionViewDataSource {
	
	let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
	private var items: [HourlyForecastViewModel] = [HourlyForecastViewModel]()
	
	var hourlyForecasts: [HourlyForecastViewModel] {
		get {
			return items
		}
		set (forecast){
			items = forecast
		}
	}
	
	
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
