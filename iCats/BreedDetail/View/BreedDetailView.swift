import SwiftUI
import SDWebImageSwiftUI


struct BreedsDetailView: View {

	@State var model: BreedDetailViewModel

	var body: some View {
		VStack() {
			ScrollView {
				ZStack(alignment: .topTrailing) {
					//					if let url = breed.image.url {
					WebImage(url: URL(string: self.model.breed.image!.url)).resizable()
						.aspectRatio(contentMode: .fill)
						.frame(width: 200, height: 200)
						.clipShape(RoundedRectangle(cornerRadius: 15))
						.padding(5)

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
						symbolColor: self.model.breed.isFavorite ? .yellow : .gray,
						backgroundColor: .black.opacity(0.2),
						action: {
							self.model.addFavorites()
						}
					)
				}
				.padding()
				.background(Color.gray.opacity(0.1))
				.cornerRadius(15)
				.shadow(radius: 5)

				VStack(alignment: .leading) {
					Text("Origin")
						.font(.system(size: 15.0))
						.fontWeight(.bold)

					Text(self.model.breed.origin)
						.font(.system(size: 15.0))
						.lineLimit(nil)
						.padding()
						.background(Color.gray.opacity(0.1))
						.cornerRadius(15)
						.shadow(radius: 5)

					Text("Temperament")
						.font(.system(size: 15.0))
						.fontWeight(.bold)

					Text(self.model.breed.temperament)
						.font(.system(size: 15.0))
						.lineLimit(nil)
						.padding()
						.background(Color.gray.opacity(0.1))
						.cornerRadius(15)
						.shadow(radius: 5)

					Text("Description")
						.font(.system(size: 15.0))
						.fontWeight(.bold)

					Text(self.model.breed.breedDescription)
						.font(.system(size: 15.0))
						.lineLimit(nil)
						.padding()
						.background(Color.gray.opacity(0.1))
						.cornerRadius(15)
						.shadow(radius: 5)
				}


				Spacer()

				TextButton(
					label: self.model.breed.isFavorite ? "Remove from Favorites" : "Add To Favorites",
					labelColor: .black,
					rectangleColor: .yellow,
					action: {
						self.model.addFavorites()
					}
				)

			}
		}
		.padding(.horizontal)
		.navigationTitle(self.model.breed.name)
		.navigationBarTitleDisplayMode(.large)
	}
}

#Preview {
	BreedsDetailView(
		model: BreedDetailViewModel(breed: BreedModel.breedMock)
	)
}
