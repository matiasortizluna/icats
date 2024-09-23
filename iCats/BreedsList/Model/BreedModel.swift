import Foundation

struct BreedModel {
	let id: String
	let name: String
	let origin: String
	let temperament: String
	let breedDescription: String
	let lifeSpan: LifespanModel
	let image: CatImageModel?
	var isFavorite : Bool

	init(id: String, name: String, origin: String, temperament: String, breedDescription: String, lifeSpan: LifespanModel, image: CatImageModel?) {
		self.id = id
		self.name = name
		self.origin = origin
		self.temperament = temperament
		self.breedDescription = breedDescription
		self.lifeSpan = lifeSpan
		self.image = image
		self.isFavorite = false
	}

	init(breedAPI : BreedAPI) {
		self.id = breedAPI.id
		self.name = breedAPI.name
		self.origin = breedAPI.origin
		self.temperament = breedAPI.temperament
		self.breedDescription = breedAPI.description
		self.lifeSpan = LifespanModel(string: breedAPI.lifeSpan)
		self.image = CatImageModel(
			id: breedAPI.image.id,
			width: breedAPI.image.width,
			height: breedAPI.image.height,
			url: breedAPI.image.url
		)
		self.isFavorite = false
	}
}

extension BreedModel {
	static var breedMock : Self =
		BreedModel(
			id: "abys",
			name: "Abyssinian",
			origin: "Egypt",
			temperament: "Active, Energetic, Independent, Intelligent, Gentle",
			breedDescription: "The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.",
			lifeSpan: LifespanModel(upperValue: 15, lowerValue: 14),
			image: CatImageModel(
				id: "0XYvRd7oD",
				width: 1204,
				height: 1445,
				url: "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg"
			)
		)
}
