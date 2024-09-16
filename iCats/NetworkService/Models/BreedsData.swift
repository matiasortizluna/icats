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
