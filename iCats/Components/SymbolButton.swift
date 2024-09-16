import Foundation
import SwiftUI

struct SymbolButton : View {
	let symbolLabel : String
	let symbolColor : Color
	let backgroundColor : Color
	let action : () -> Void

	var body : some View {
		Button(
			action: action
		) {
			Image(systemName: symbolLabel)
				.font(.system(size: 20.0))
				.foregroundColor(symbolColor)
				.padding(5)
				.background(
					Circle()
						.foregroundColor(backgroundColor)
				)
				.offset(x: -10, y: 10)
		}
	}
}

#Preview {
	SymbolButton(
		symbolLabel: "star.fill",
		symbolColor: .yellow,
		backgroundColor: .black,
		action: {}
	)
}
