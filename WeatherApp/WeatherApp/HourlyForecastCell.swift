import Foundation

import UIKit

@IBDesignable class HourlyForecastCell: UICollectionViewCell {
	@IBOutlet weak var temperature: UILabel!
	@IBOutlet weak var hour: UILabel!
	@IBOutlet weak var condition: UILabel!

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	var viewModel: HourlyForecastViewModel? {
		get { return nil}
		set (forecast) {
			temperature.text = forecast?.temperature
			hour.text = forecast?.when
			condition.text = forecast?.weather
		}

	}

	func setup() {
		if let view = loadViewFromNib() {
			view.frame = bounds
			view.autoresizingMask = [UIViewAutoresizing.flexibleWidth,
									UIViewAutoresizing.flexibleHeight]
			addSubview(view)
		}
	}

	func loadViewFromNib() -> UIView? {
		let bundle = Bundle(for: type(of: self))
		let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
		return nib.instantiate(withOwner: self, options: nil)[0] as? UIView
	}
}
