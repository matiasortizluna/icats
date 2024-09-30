import Foundation

public struct Breed: Decodable, Equatable {
	let id: String
	let name: String
	let temperament: String
	let origin: String
	let description: String
	let lifeSpan: String
	let referenceImageID: String?
	let image: CatImage?

	enum CodingKeys: String, CodingKey {
		case id, name, temperament, origin, description
		case lifeSpan = "life_span"
		case referenceImageID = "reference_image_id"
		case image
	}
}

extension [Breed] {
	// swiftlint:disable line_length
	static var breedsMock: Self = [
		Breed(
			id: "abys",
			name: "Abyssinian",
			temperament: "Active, Energetic, Independent, Intelligent, Gentle",
			origin: "Egypt",
			description: "The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.",
			lifeSpan: "14 - 15",
			referenceImageID: "0XYvRd7oD",
			image: CatImage(
				id: "0XYvRd7oD",
				width: 1204,
				height: 1445,
				url: "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg"
			)
		),
		Breed(
			id: "aege",
			name: "Aegean",
			temperament: "Affectionate, Social, Intelligent, Playful, Active",
			origin: "Greece",
			description: "Native to the Greek islands known as the Cyclades in the Aegean Sea, these are natural cats, meaning they developed without humans getting involved in their breeding. As a breed, Aegean Cats are rare, although they are numerous on their home islands. They are generally friendly toward people and can be excellent cats for families with children.",
			lifeSpan: "9 - 12",
			referenceImageID: "ozEvzdVM-",
			image: CatImage(
				id: "ozEvzdVM-",
				width: 1200,
				height: 800,
				url: "https://cdn2.thecatapi.com/images/ozEvzdVM-.jpg"
			)
		),
		Breed(
			id: "abob",
			name: "American Bobtail",
			temperament: "Intelligent, Interactive, Lively, Playful, Sensitive",
			origin: "United States",
			description: "American Bobtails are loving and incredibly intelligent cats possessing a distinctive wild appearance. They are extremely interactive cats that bond with their human family with great devotion.",
			lifeSpan: "11 - 15",
			referenceImageID: "hBXicehMA",
			image: CatImage(
				id: "hBXicehMA",
				width: 1600,
				height: 951,
				url: "https://cdn2.thecatapi.com/images/hBXicehMA.jpg"
			)
		),
		Breed(
			id: "acur",
			name: "American Curl",
			temperament: "Affectionate, Curious, Intelligent, Interactive, Lively, Playful, Social",
			origin: "United States",
			description: "Distinguished by truly unique ears that curl back in a graceful arc, offering an alert, perky, happily surprised expression, they cause people to break out into a big smile when viewing their first Curl. Curls are very people-oriented, faithful, affectionate soulmates, adjusting remarkably fast to other pets, children, and new situations.",
			lifeSpan: "12 - 16",
			referenceImageID: "xnsqonbjW",
			image: CatImage(
				id: "xnsqonbjW",
				width: 1000,
				height: 964,
				url: "https://cdn2.thecatapi.com/images/xnsqonbjW.jpg"
			)
		),
		Breed(
			id: "asho",
			name: "American Shorthair",
			temperament: "Active, Curious, Easy Going, Playful, Calm",
			origin: "United States",
			description: "The American Shorthair is known for its longevity, robust health, good looks, sweet personality, and amiability with children, dogs, and other pets.",
			lifeSpan: "15 - 17",
			referenceImageID: "JFPROfGtQ",
			image: CatImage(
				id: "JFPROfGtQ",
				width: 1600,
				height: 1200,
				url: "https://cdn2.thecatapi.com/images/JFPROfGtQ.jpg"
			)
		),
		Breed(
			id: "awir",
			name: "American Wirehair",
			temperament: "Affectionate, Curious, Gentle, Intelligent, Interactive, Lively, Loyal, Playful, Sensible, Social",
			origin: "United States",
			description: "The American Wirehair tends to be a calm and tolerant cat who takes life as it comes. His favorite hobby is bird-watching from a sunny windowsill, and his hunting ability will stand you in good stead if insects enter the house.",
			lifeSpan: "14 - 18",
			referenceImageID: "8D--jCd21",
			image: CatImage(
				id: "8D--jCd21",
				width: 1280,
				height: 936,
				url: "https://cdn2.thecatapi.com/images/8D--jCd21.jpg"
			)
		),
		Breed(
			id: "amau",
			name: "Arabian Mau",
			temperament: "Affectionate, Agile, Curious, Independent, Playful, Loyal",
			origin: "United Arab Emirates",
			description: "Arabian Mau cats are social and energetic. Due to their energy levels, these cats do best in homes where their owners will be able to provide them with plenty of playtime, attention and interaction from their owners. These kitties are friendly, intelligent, and adaptable, and will even get along well with other pets and children.",
			lifeSpan: "12 - 14",
			referenceImageID: "k71ULYfRr",
			image: CatImage(
				id: "k71ULYfRr",
				width: 2048,
				height: 1554,
				url: "https://cdn2.thecatapi.com/images/k71ULYfRr.jpg"
			)
		),
		Breed(
			id: "amis",
			name: "Australian Mist",
			temperament: "Lively, Social, Fun-loving, Relaxed, Affectionate",
			origin: "Australia",
			description: "The Australian Mist thrives on human companionship. Tolerant of even the youngest of children, these friendly felines enjoy playing games and being part of the hustle and bustle of a busy household. They make entertaining companions for people of all ages, and are happy to remain indoors between dusk and dawn or to be wholly indoor pets.",
			lifeSpan: "12 - 16",
			referenceImageID: "_6x-3TiCA",
			image: CatImage(
				id: "_6x-3TiCA",
				width: 1231,
				height: 1165,
				url: "https://cdn2.thecatapi.com/images/_6x-3TiCA.jpg"
			)
		),
	]
	// swiftlint:enable line_length
}
