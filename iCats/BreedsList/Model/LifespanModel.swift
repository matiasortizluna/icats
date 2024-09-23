import Foundation

struct LifespanModel {
	let upperValue : Int
	let lowerValue : Int

	init(upperValue: Int, lowerValue: Int) {
		self.upperValue = upperValue
		self.lowerValue = lowerValue
	}

	init(string : String) {
//		[0-9]{2}[^0-9]+[0-9]{2}
		let result = string.split(separator: " ").map { String($0) }

		if result.first != nil {
			self.upperValue = Int(result.first!) ?? 99
		} else {
			self.upperValue = 99
			print("Unable to transform String to Int. Setting to default value self.lowerValue")
		}

		if result.last != nil {
			self.lowerValue = Int(result.last!) ?? 99
		} else {
			self.lowerValue = 99
			print("Unable to transform String to Int. Setting to default value self.lowerValue")
		}
	}
}
