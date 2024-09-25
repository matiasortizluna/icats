import Foundation
import SwiftUI

// TODO: Really nice that you created this reusable view!
// My suggestion here is just to keep some properties fixed (to match a possible design system). We can talk about this later.
struct SymbolButton : View {
	let symbolLabel : String
	let symbolColor : Color
	let backgroundColor : Color
	let action : () -> Void

	var body : some View {
		Button(
			action: action
		) {
			// TODO: Could you add these values to an extension? It might be a good idea to have a file with font types
			// But we can do this later
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
