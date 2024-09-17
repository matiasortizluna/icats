//
//  Breeds.swift
//  iCats
//
//  Created by Matias Luna on 12/09/2024.
//

import Foundation

public struct BreedsData: Decodable, Equatable {
	let weight: WeightData
	let id, name, temperament, origin: String
	let description, lifeSpan, referenceImageID: String
	let image: CatImageData

	enum CodingKeys: String, CodingKey {
		case weight, id, name, temperament, origin, description
		case lifeSpan = "life_span"
		case referenceImageID = "reference_image_id"
		case image
	}
}

struct CatImageData: Decodable, Equatable {
	let id: String
	let width, height: Int
	let url: String
}

struct WeightData: Decodable, Equatable {
	let imperial, metric: String
}

extension [BreedsData] {
	static var breedsMock : Self = [
		BreedsData(
			weight: WeightData(
				imperial: "7  -  10",
				metric: "3 - 5"
			),
			id: "abys",
			name: "Abyssinian",
			temperament: "Active, Energetic, Independent, Intelligent, Gentle",
			origin: "Egypt",
			description: "The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.",
			lifeSpan: "14 - 15",
			referenceImageID: "0XYvRd7oD",
			image: CatImageData(
				id: "0XYvRd7oD",
				width: 1204,
				height: 1445,
				url: "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg"
			)
		),
		BreedsData(
			weight: WeightData(
				imperial: "7 - 10",
				metric: "3 - 5"
			),
			id: "aege",
			name: "Aegean",
			temperament: "Affectionate, Social, Intelligent, Playful, Active",
			origin: "Greece",
			description: "Native to the Greek islands known as the Cyclades in the Aegean Sea, these are natural cats, meaning they developed without humans getting involved in their breeding. As a breed, Aegean Cats are rare, although they are numerous on their home islands. They are generally friendly toward people and can be excellent cats for families with children.",
			lifeSpan: "9 - 12",
			referenceImageID: "ozEvzdVM-",
			image: CatImageData(
				id: "ozEvzdVM-",
				width: 1200,
				height: 800,
				url: "https://cdn2.thecatapi.com/images/ozEvzdVM-.jpg"
			)
		),
		BreedsData(
			weight: WeightData(
				imperial: "6 - 15",
				metric: "3 - 7"
			),
			id: "char",
			name: "Chartreux",
			temperament: "Affectionate, Loyal, Intelligent, Social, Lively, Playful",
			origin: "France",
			description: "The Chartreux is generally silent but communicative. Short play sessions, mixed with naps and meals are their perfect day. Whilst appreciating any attention you give them, they are not demanding, content instead to follow you around devotedly, sleep on your bed and snuggle with you if you’re not feeling well.",
			lifeSpan: "12 - 15",
			referenceImageID: "j6oFGLpRG",
			image: CatImageData(
				id: "j6oFGLpRG",
				width: 768,
				height: 1024,
				url: "https://cdn2.thecatapi.com/images/j6oFGLpRG.jpg"
			)
		)
	]
}
