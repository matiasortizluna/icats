import Foundation

struct LifespanModel {
	let upperValue: Int
	let lowerValue: Int

	init(upperValue: Int, lowerValue: Int) {
		self.upperValue = upperValue
		self.lowerValue = lowerValue
	}

	init?(string: String) {
		//		[0-9]{2}[^0-9]+[0-9]{2}
		let result = string.split(separator: " - ").compactMap { Int(String($0)) }

		guard let lowerValue = result.first else { return nil }
		guard let upperValue = result.last else { return nil }

		self.lowerValue = lowerValue
		self.upperValue = upperValue
	}
}
