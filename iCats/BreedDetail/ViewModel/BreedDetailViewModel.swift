import Foundation

@Observable
public class BreedDetailViewModel: Equatable {
	var breed: BreedModel

	func addFavorites() {
		breed.isFavorite.toggle()
	}

	init(breed: BreedModel) {
		self.breed = breed
	}

	public static func == (lhs: BreedDetailViewModel, rhs: BreedDetailViewModel) -> Bool {
		return lhs.breed == rhs.breed
	}
}
