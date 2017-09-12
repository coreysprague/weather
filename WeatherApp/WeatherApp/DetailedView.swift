import UIKit

@IBDesignable class DetailedView: UIView {
	var view: UIView!
	@IBOutlet weak var sunrise: UILabel!
	@IBOutlet weak var sunset: UILabel!
	@IBOutlet weak var humidity: UILabel!
	@IBOutlet weak var visibility: UILabel!
	@IBOutlet weak var wind: UILabel!
	@IBOutlet weak var pressure: UILabel!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	var viewModel : DetailsViewModel? {
		get { return nil}
		set (details) {
			sunrise.text = details?.sunrise
			sunset.text = details?.sunset
			humidity.text = details?.humidity
			visibility.text = details?.visibility
			wind.text = details?.wind
			pressure.text = details?.pressure
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
