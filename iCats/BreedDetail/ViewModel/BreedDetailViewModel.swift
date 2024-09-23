//
//  BreedDetailViewModel.swift
//  iCats
//
//  Created by Matias Luna on 20/09/2024.
//

import Foundation

@Observable
final class BreedDetailViewModel {

	var breed : BreedModel

	func addFavorites() {
		self.breed.isFavorite.toggle()
	}

	init(breed: BreedModel) {
		self.breed = breed
	}

}
