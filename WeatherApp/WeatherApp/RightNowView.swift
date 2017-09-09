import UIKit

@IBDesignable class RightNowView: UIView {
	var view: UIView!
	
	@IBOutlet weak var location: UILabel!
	@IBOutlet weak var temperature: UILabel!
	@IBOutlet weak var forecastDescription: UILabel!
	@IBOutlet weak var lastUpdated: UILabel!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	var viewModel : WeatherViewModel? {
		get { return nil}
		set (forecast) {
			location.text = forecast?.location
			temperature.text = forecast?.today?.temp
			forecastDescription.text = forecast?.today?.description
			lastUpdated.text = forecast?.lastUpdated
		}
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
