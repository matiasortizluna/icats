import CoreData
import Foundation

extension DatabaseService {
	func readBreeds() async throws -> [BreedModel] {
		guard let breedsEntity = try await fetchObjects(DatabaseEntity.breed, [NSSortDescriptor(key: "name", ascending: true)]) as? [BreedEntity] else {
			throw DatabaseServiceError.wrongTransformation
		}
		return breedsEntity.map { BreedModel(breedEntity: $0 ) }
	}

	func insertBreed(_ breed: BreedModel) async throws {
		let context = try await self.newBackgroundContext()
		try context.performAndWait {
			guard
				let entity = NSEntityDescription.entity(forEntityName: DatabaseEntity.breed.rawValue, in: context),
				let newBreed = NSManagedObject(entity: entity, insertInto: context) as? BreedEntity
			else { throw DatabaseServiceError.noEntity }

			newBreed.id = breed.id
			newBreed.name = breed.name
			newBreed.origin = breed.origin
			newBreed.temperament = breed.temperament
			newBreed.breedDescription = breed.breedDescription
			newBreed.lifeSpanLowerValue = breed.lifeSpan != nil ? Int16(breed.lifeSpan!.lowerValue) : Int16(99)
			newBreed.lifeSpanUpperValue = breed.lifeSpan != nil ? Int16(breed.lifeSpan!.upperValue) : Int16(99)
			newBreed.isFavorite = breed.isFavorite
			newBreed.image = nil

			do {
				try context.save()
			} catch {
				assertionFailure("1st: Error managedContext.save() \(error) \(error.localizedDescription)")
			}
		}
	}
}
