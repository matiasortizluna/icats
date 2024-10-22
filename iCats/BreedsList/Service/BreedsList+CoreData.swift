import CoreData
import Foundation

extension DatabaseService {
	internal func readBreeds() async throws -> [BreedModel] {
		guard let breedsEntity = try await fetchObjects(DatabaseEntity.breed, [NSSortDescriptor(key: "name", ascending: true)]) as? [BreedEntity] else {
			throw DatabaseServiceError.wrongTransformation
		}
		return breedsEntity.map { BreedModel(breedEntity: $0 ) }
	}

	internal func insertBreed(_ breed: BreedModel) async throws {
		let context = try await self.newBackgroundContext()
		try context.performAndWait {
			guard
				let breedEntity = NSEntityDescription.entity(forEntityName: DatabaseEntity.breed.rawValue, in: context),
				let newBreed = NSManagedObject(entity: breedEntity, insertInto: context) as? BreedEntity
			else { throw DatabaseServiceError.noEntity }

			newBreed.id = breed.id
			newBreed.name = breed.name
			newBreed.origin = breed.origin
			newBreed.temperament = breed.temperament
			newBreed.breedDescription = breed.breedDescription
			newBreed.lifeSpanLowerValue = breed.lifeSpan != nil ? Int16(breed.lifeSpan!.lowerValue) : Int16(99)
			newBreed.lifeSpanUpperValue = breed.lifeSpan != nil ? Int16(breed.lifeSpan!.upperValue) : Int16(99)
			newBreed.isFavorite = breed.isFavorite

			if breed.image != nil {
				guard
					let catImageEntity = NSEntityDescription.entity(forEntityName: DatabaseEntity.catImage.rawValue, in: context),
					let catImage = NSManagedObject(entity: catImageEntity, insertInto: context) as? CatImageEntity
				else { throw DatabaseServiceError.noEntity }

				catImage.id = breed.image!.id
				catImage.url = breed.image!.url
				catImage.height = Int16(breed.image!.height)
				catImage.width = Int16(breed.image!.width)

				newBreed.image = catImage
			} else {
				newBreed.image = nil
			}

			do {
				try context.save()
			} catch {
				assertionFailure("1st: Error managedContext.save() \(error) \(error.localizedDescription)")
			}
		}
	}
}
