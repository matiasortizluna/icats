
import Foundation

extension DatabaseService {

	func fetchBreeds() -> [BreedModel] {
		do {
			let breedsEntity = try fetchObjects(DatabaseEntity.breed, nil)
			return breedsEntity.map { BreedModel(breedEntity: $0 as! BreedEntity) }
		} catch {
			print("Error fetching breed: \(error.localizedDescription)")
		}
		return []
	}

	func insertBreed(_ breed: BreedModel) {
		do {
			print("insert")
			let newBreed: BreedEntity = try self.createObject(DatabaseEntity.breed) as! BreedEntity
			newBreed.id = breed.id
			newBreed.name = breed.name
			newBreed.origin = breed.origin
			newBreed.temperament = breed.temperament
			newBreed.breedDescription = breed.breedDescription
			newBreed.lifeSpan = "\(String(breed.lifeSpan!.lowerValue)) - \(String(breed.lifeSpan!.upperValue))"
			newBreed.isFavorite = breed.isFavorite
			newBreed.image = nil
			try save()
			print("saved")
		} catch {
			print("Error saving breeds on disk: \(error.localizedDescription)")
		}
	}
}
