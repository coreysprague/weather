import Foundation

struct Wind: Equatable {
	let speed: Measurement<UnitSpeed>
	let deg: Measurement<UnitAngle>

	static func == (left: Wind, right: Wind) -> Bool {
		return
			left.speed == right.speed &&
			left.deg == right.deg
	}
}
