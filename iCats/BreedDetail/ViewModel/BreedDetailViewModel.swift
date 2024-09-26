import Foundation

@Observable
final class BreedDetailViewModel {
	var breed: BreedModel

	func addFavorites() {
		breed.isFavorite.toggle()
	}

	init(breed: BreedModel) {
		self.breed = breed
	}
}
