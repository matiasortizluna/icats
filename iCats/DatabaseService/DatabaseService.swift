import Foundation
import CoreData

@Observable
class DatabaseService {
	static let shared = DatabaseService()

	var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "iCats")

		container.loadPersistentStores { _, error in
			if let error {
				fatalError("Failed to load persistent stores: \(error.localizedDescription)")
			}
		}
		return container
	}()

	init() { }

	func fetchBreeds() -> [BreedModel] {
		do {
			let breedsEntity = try fetchData()
			return breedsEntity.map { BreedModel(breedEntity: $0) }
		} catch {
			print("Error fetching breed: \(error.localizedDescription)")
		}
		return []
	}

	func saveOnDisk(breeds: [BreedModel]) {
		do {
			for breed in breeds {
				let newBreed = BreedEntity(context: persistentContainer.viewContext)
				newBreed.id = breed.id
				newBreed.name = breed.name
				newBreed.origin = breed.origin
				newBreed.temperament = breed.temperament
				newBreed.breedDescription = breed.breedDescription
				newBreed.lifeSpan = "\(String(breed.lifeSpan!.lowerValue)) - \(String(breed.lifeSpan!.upperValue))"
				newBreed.isFavorite = breed.isFavorite
				newBreed.image = nil
				try saveContext()
			}
		} catch {
			print("Error saving breeds on disk: \(error.localizedDescription)")
		}
	}

	func updateBreed(breed: Breed) {
		do {
			// update breed
			try saveContext()
		} catch {
			print("Error updating breed: \(error.localizedDescription)")
		}
	}

	func cleanBD() {
		do {
			let breeds = try fetchData()
			for breed in breeds {
				persistentContainer.viewContext.delete(breed)
				try saveContext()
			}
		} catch {
			print("Error cleaning DB \(error.localizedDescription)")
		}
	}

	private func fetchData() throws -> [BreedEntity] {
		let request: NSFetchRequest<BreedEntity> = BreedEntity.fetchRequest()
		let breedsEntity = try persistentContainer.viewContext.fetch(request)
		return breedsEntity
	}

	private func saveContext() throws {
		guard persistentContainer.viewContext.hasChanges else { return }
		do {
			persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
			try persistentContainer.viewContext.save()
		} catch {
			print("Core Data error: \(error.localizedDescription)")
		}
	}
}
