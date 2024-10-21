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

	init(
		breedEntity: BreedEntity
	) {
		id = breedEntity.id!
		name = breedEntity.name!
		origin = breedEntity.origin!
		temperament = breedEntity.temperament!
		breedDescription = breedEntity.breedDescription!
		lifeSpan = LifespanModel(upperValue: Int(breedEntity.lifeSpanUpperValue), lowerValue: Int(breedEntity.lifeSpanLowerValue))
		if breedEntity.image != nil {
			image = CatImageModel(
				id: breedEntity.image!.id!,
				width: Int(breedEntity.image!.width),
				height: Int(breedEntity.image!.height),
				url: breedEntity.image!.url!
			)
		} else {
			image = nil
		}
		isFavorite = false
	}
}

extension BreedModel {
	static var breedMock: Self = BreedModel(
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

extension [BreedModel] {
	// swiftlint:disable line_length
	static var breedsMock: Self = [
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
		),
		BreedModel(
			id: "aege",
			name: "Aegean",
			origin: "Greece",
			temperament: "Affectionate, Social, Intelligent, Playful, Active",
			breedDescription: "Native to the Greek islands known as the Cyclades in the Aegean Sea, these are natural cats, meaning they developed without humans getting involved in their breeding. As a breed, Aegean Cats are rare, although they are numerous on their home islands. They are generally friendly toward people and can be excellent cats for families with children.",
			lifeSpan: LifespanModel(
				upperValue: 12,
				lowerValue: 9
			),
			image: CatImageModel(
				id: "ozEvzdVM-",
				width: 1200,
				height: 800,
				url: "https://cdn2.thecatapi.com/images/ozEvzdVM-.jpg"
			)
		),
		BreedModel(
			id: "char",
			name: "Chartreux",
			origin: "France",
			temperament: "Affectionate, Loyal, Intelligent, Social, Lively, Playful",
			breedDescription: "The Chartreux is generally silent but communicative. Short play sessions, mixed with naps and meals are their perfect day. Whilst appreciating any attention you give them, they are not demanding, content instead to follow you around devotedly, sleep on your bed and snuggle with you if you’re not feeling well.",
			lifeSpan: LifespanModel(
				upperValue: 15,
				lowerValue: 12
			),
			image: CatImageModel(
				id: "j6oFGLpRG",
				width: 768,
				height: 1024,
				url: "https://cdn2.thecatapi.com/images/j6oFGLpRG.jpg"
			)
		)
	]
	// swiftlint:enable line_length
}
