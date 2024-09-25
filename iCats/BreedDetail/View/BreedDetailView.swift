import SwiftUI
import SDWebImageSwiftUI

struct BreedsDetailView: View {
	@State var model: BreedDetailViewModel

	var body: some View {
		VStack(spacing: .zero) {
			ScrollView {
				ZStack(alignment: .topTrailing) {
					//					if let url = breed.image.url {
					WebImage(url: URL(string: model.breed.image!.url)).resizable()
						.aspectRatio(contentMode: .fill)
						.frame(width: .webImageWidth, height: .webImageHeight)
						.clipShape(RoundedRectangle(cornerRadius: .webImageCornerRadius))
						.padding(.webImagePadding)

					//                    } else {
					//                        Image(systemName: "cat.fill")
					//                            .resizable()
					//                            .aspectRatio(contentMode: .fill)
					//                            .frame(width: 200, height: 200)
					//                            .clipShape(RoundedRectangle(cornerRadius: 15))
					//                            .padding(5)
					//                    }

					SymbolButton(
						symbolLabel: "star.fill",
						symbolColor: model.breed.isFavorite ? .symbolFavoriteTrueColor : .symbolFavoriteFalseColor,
						backgroundColor: .black.opacity(.symbolBackgroundOpacity),
						action: {
							model.addFavorites()
						}
					)
				}
				.padding()
				.background(Color.gray.opacity(.webImageBackgroundOpacity))
				.cornerRadius(.webImageBackgroundCornerRadius)
				.shadow(radius: .webImageBackgroundShadow)

				VStack(alignment: .leading, spacing: .zero) {
					Text("Origin")
						.font(.system(size: .elementFontSize))
						.fontWeight(.bold)

					Text(model.breed.origin)
						.font(.system(size: .elementFontSize))
						.lineLimit(nil)
						.padding()
						.background(Color.gray.opacity(.textBackgroundOpacity))
						.cornerRadius(.textBackgroundCornerRadius)
						.shadow(radius: .textBackgroundShadow)

					Text("Temperament")
						.font(.system(size: .elementFontSize))
						.fontWeight(.bold)

					Text(model.breed.temperament)
						.font(.system(size: .elementFontSize))
						.lineLimit(nil)
						.padding()
						.background(Color.gray.opacity(.textBackgroundOpacity))
						.cornerRadius(.textBackgroundCornerRadius)
						.shadow(radius: .textBackgroundShadow)

					Text("Description")
						.font(.system(size: .elementFontSize))
						.fontWeight(.bold)

					Text(model.breed.breedDescription)
						.font(.system(size: .elementFontSize))
						.lineLimit(nil)
						.padding()
						.background(Color.gray.opacity(.textBackgroundOpacity))
						.cornerRadius(.textBackgroundCornerRadius)
						.shadow(radius: .textBackgroundShadow)
				}

				Spacer()

				TextButton(
					label: model.breed.isFavorite ? "Remove from Favorites" : "Add To Favorites",
					labelColor: .buttonAddFavoriteLabelColor,
					rectangleColor: .buttonAddFavoriteBackgroundColor,
					action: {
						model.addFavorites()
					}
				)

			}
		}
		.padding(.horizontal)
		.navigationTitle(model.breed.name)
		.navigationBarTitleDisplayMode(.large)
	}
}

private extension Color {
	static let symbolFavoriteTrueColor: Self = .yellow
	static let symbolFavoriteFalseColor: Self = .gray
	static let buttonAddFavoriteBackgroundColor: Self = .yellow
	static let buttonAddFavoriteLabelColor: Self = .black
}

private extension CGFloat {
	static let webImageWidth: Self = 200
	static let webImageHeight: Self = 200
	static let webImageCornerRadius: Self = 15
	static let webImagePadding: Self = 5
	static let webImageBackgroundCornerRadius: Self = 15
	static let webImageBackgroundShadow: Self = 5
	static let elementFontSize: Self = 15.0
	static let textBackgroundCornerRadius: Self = 15
	static let textBackgroundShadow: Self = 5
}

// TODO: could you add a extension String { } with the string literals in this file? Since we can reuse the strings elsewhere
// it might be a good approach to create this extension in a separate file accessible to every view.

private extension Double {
	static let symbolBackgroundOpacity: Self = 0.2
	static let webImageBackgroundOpacity: Self = 0.1
	static let textBackgroundOpacity: Self = 0.1
}

#Preview {
	BreedsDetailView(
		model: BreedDetailViewModel(breed: BreedModel.breedMock)
	)
}
