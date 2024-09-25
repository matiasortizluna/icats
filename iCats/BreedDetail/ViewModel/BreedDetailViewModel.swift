//
//  BreedDetailViewModel.swift
//  iCats
//
//  Created by Matias Luna on 20/09/2024.
//

import Foundation

@Observable
final class BreedDetailViewModel {
	// TODO: delete this line
	var breed : BreedModel

	func addFavorites() {
		breed.isFavorite.toggle()
	}

	init(breed: BreedModel) {
		self.breed = breed
	}
	// TODO: delete this line
}
