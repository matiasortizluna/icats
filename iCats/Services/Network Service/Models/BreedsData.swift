//
//  Breeds.swift
//  iCats
//
//  Created by Matias Luna on 12/09/2024.
//

import Foundation

struct BreedsData : Decodable {
	let id: String
	let name: String
	let origin: String
	let temperament: String
	let breedDescription: String
	let image: CatImageData?
	var isFavorite: Bool

	enum CodingKeys : String, CodingKey {
		case id = "id"
		case name = "name"
		case origin = "origin"
		case temperament = "temperament"
		case breedDescription = "description"
		case image = "image"
		case isFavorite = "isFavorite"
	}
}

struct CatImageData : Decodable {

	let id: String
	let width: String
	let height: String
	let url: String

	enum CodingKeys : String, CodingKey {
		case id = "id"
		case width = "width"
		case height = "height"
		case url = "url"
	}
}
