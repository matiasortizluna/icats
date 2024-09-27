import Foundation

struct BreedModel: Identifiable, Equatable {
	let id: String
	let name: String
	let origin: String
	let temperament: String
	let breedDescription: String
	let lifeSpan: LifespanModel?
	let image: CatImageModel?
	var isFavorite: Bool

	init(
		id: String,
		name: String,
		origin: String,
		temperament: String,
		breedDescription: String,
		lifeSpan: LifespanModel,
		image: CatImageModel?
	) {
		self.id = id
		self.name = name
		self.origin = origin
		self.temperament = temperament
		self.breedDescription = breedDescription
		self.lifeSpan = lifeSpan
		self.image = image
		isFavorite = false
	}

	init(
		breedAPI: Breed
	) {
		id = breedAPI.id
		name = breedAPI.name
		origin = breedAPI.origin
		temperament = breedAPI.temperament
		breedDescription = breedAPI.description
		lifeSpan = LifespanModel(string: breedAPI.lifeSpan)
		if let unwrappedImage = breedAPI.image {
			image = CatImageModel(
				id: unwrappedImage.id,
				width: unwrappedImage.width,
				height: unwrappedImage.height,
				url: unwrappedImage.url
			)
		} else {
			image = nil
		}
		isFavorite = false
	}
}

extension BreedModel {
	static var breedMock: Self =
	BreedModel(
		id: "abys",
		name: "Abyssinian",
		origin: "Egypt",
		temperament: "Active, Energetic, Independent, Intelligent, Gentle",
		breedDescription: "The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.",
		lifeSpan: LifespanModel(
			upperValue: 15,
			lowerValue: 14
		),
		image: CatImageModel(
			id: "0XYvRd7oD",
			width: 1204,
			height: 1445,
			url: "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg"
		)
	)
}
