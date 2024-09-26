import Foundation
import SwiftUI

struct StarButton: View {
	let model : BreedDetailViewModel

	var body: some View {
		Button(action: {
			model.addFavorites()
		}, label: {
			// Could you add these values to an extension? It might be a good idea to have a file with font types
			// But we can do this later
			Image.star
				.font(.starImageFont)
				.foregroundColor(model.breed.isFavorite ? .symbolFavoriteTrueColor : .symbolFavoriteFalseColor)
				.padding(Double.starButtonPadding)
				.background(Circle().foregroundColor(Color.backgroundColor))
				.offset(x: .offsetX, y: .offsetY)
		})
	}
}

private extension Image {
	static let star: Self = .init(systemName: "star.fill")
}

private extension Font {
	static let starImageFont: Self = Font.system(size: 20.0)
}

private extension Double {
	static let starButtonPadding: Self = 5
	static let symbolBackgroundOpacity: Self = 0.2
}

private extension CGFloat {
	static let offsetX: Self = -10
	static let offsetY: Self = 10
}

private extension Color {
	static let symbolFavoriteTrueColor: Self = .yellow
	static let symbolFavoriteFalseColor: Self = .gray
	static let backgroundColor: Self = .black.opacity(.symbolBackgroundOpacity)
}

#Preview {
	StarButton(model: BreedDetailViewModel(breed: .breedMock))
}
