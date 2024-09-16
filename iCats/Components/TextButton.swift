import Foundation
import SwiftUI

struct TextButton : View {
	let label : String
	let labelColor : Color
	let rectangleColor : Color
	let action : () -> Void

	var body : some View {
		Button(
			action: action
		) {
			Text(label)
				.font(.headline)
				.foregroundColor(labelColor)
				.padding()
				.background(
					Rectangle()
						.foregroundColor(rectangleColor)
						.cornerRadius(15.0)
				)
		}
		.cornerRadius(15.0)
		.padding()
	}
	
}

#Preview {
	TextButton(
		label: "Hello World!",
		labelColor: .black,
		rectangleColor: .yellow,
		action: {}
	)
}
