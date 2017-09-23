import UIKit

class HourlyForecastDataSource: NSObject, UICollectionViewDataSource {

	let reuseIdentifier = "cell"
	private var items: [HourlyForecastViewModel] = [HourlyForecastViewModel]()

	var hourlyForecasts: [HourlyForecastViewModel] {
		get {
			return items
		}
		set (forecast) {
			items = forecast
		}
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.items.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath)
		if let forecastCell = cell as? HourlyForecastCell {
			forecastCell.viewModel = self.items[indexPath.item]
		}
		return cell
	}
}
