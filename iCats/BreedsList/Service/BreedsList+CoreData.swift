import Foundation

extension DatabaseService {

	func readBreeds() async throws -> [BreedModel] {
		guard let breedsEntity = try await fetchObjects(DatabaseEntity.breed, nil) as? [BreedEntity] else {
			throw DatabaseServiceError.wrongTransformation
		}
		return breedsEntity.map { BreedModel(breedEntity: $0 ) }
	}

	func insertBreed(_ breed: BreedModel) async throws {
		guard let newBreed: BreedEntity = try await self.createObject(DatabaseEntity.breed) as? BreedEntity, let context = newBreed.managedObjectContext else {
			throw DatabaseServiceError.wrongTransformation
		}
		context.performAndWait {
			newBreed.id = breed.id
			newBreed.name = breed.name
			newBreed.origin = breed.origin
			newBreed.temperament = breed.temperament
			newBreed.breedDescription = breed.breedDescription
			newBreed.lifeSpan = "\(String(breed.lifeSpan!.lowerValue)) - \(String(breed.lifeSpan!.upperValue))"
			newBreed.isFavorite = breed.isFavorite
			newBreed.image = nil
		}
	}
}
