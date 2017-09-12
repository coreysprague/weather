import Foundation

class TemperatureFormatter : MeasurementFormatter {
	override init(){
		super.init()
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	private func setup(){
		let temperatureValueFormatter = NumberFormatter()
		temperatureValueFormatter.maximumFractionDigits = 0
		self.numberFormatter = temperatureValueFormatter
		self.unitStyle = .short
	}
}
