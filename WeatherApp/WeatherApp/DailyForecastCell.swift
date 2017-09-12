
import UIKit

@IBDesignable class DailyForecastCell: UITableViewCell {
	var view: UIView!
	
	@IBOutlet weak var dayOfWeek: UILabel!
	@IBOutlet weak var weather: UILabel!
	@IBOutlet weak var highTemp: UILabel!
	@IBOutlet weak var lowTemp: UILabel!
	
	var viewModel : DailyForecastViewModel? {
		get { return nil}
		set (forecast) {
			dayOfWeek.text = forecast?.dayOfWeek
			weather.text = forecast?.weather
			highTemp.text = forecast?.highTemp
			lowTemp.text = forecast?.lowTemp
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setup()
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
