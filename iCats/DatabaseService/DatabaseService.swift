import Foundation
import CoreData

public struct DatabaseService {
	public let fetchObjects: (_ entity: DatabaseEntity, _ sort: [NSSortDescriptor]?) throws -> [Any]
	public let createObject: (_ entity: DatabaseEntity) throws -> Any
	public let save: () throws -> Void
	public let deleteAll: (_ entities: [DatabaseEntity]) throws -> Void
	public let delete: (_ object: NSManagedObject) throws -> Void
}

extension DatabaseService {
	public static func liveContainer(_ persistentContainerName: String) -> NSPersistentContainer {
		let persitentContainer = NSPersistentContainer(name: persistentContainerName)
		initializePersistentContainer(persistentContainer: persitentContainer)
		return persitentContainer
	}

	public static func initializePersistentContainer(persistentContainer: NSPersistentContainer) {
		persistentContainer.loadPersistentStores { _, error in
			if let error {
				fatalError("Failed to load persistent stores: \(error.localizedDescription)")
			}
		}
	}

//	public func mockContainer() {
//		let persitentContainer = NSPersistentContainer(name: "persistentContainerName")
//		initializePersistentContainer(persistentContainer: persitentContainer)
//		return persitentContainer
//	}

	public static func live(persistentContainer: NSPersistentContainer = liveContainer("iCats")) -> Self {
		let managedContext: NSManagedObjectContext = persistentContainer.viewContext

		return .init { entity, _ in
			managedContext.performAndWait {
				return fetchObjectsRequest(
					entity: entity,
					managedContext: managedContext
				)
			}
		} createObject: { entity in
			managedContext.performAndWait {
				if let entity = NSEntityDescription.entity(forEntityName: entity.rawValue, in: managedContext) {
					let object = NSManagedObject(entity: entity, insertInto: managedContext)
//					completion(.success(object))
					return object
				} else {
//					completion(.failure(DatabaseServiceError.noEntity))
				}
				return []
			}
		} save: {
			managedContext.performAndWait {
				saveChanges(managedContext)
			}
		} deleteAll: { entities in
			managedContext.performAndWait {
				entities
					.map(\.rawValue)
					.map(NSFetchRequest<NSFetchRequestResult>.init(entityName:))
					.map {
						$0.includesPropertyValues = false
						return $0
					}
					.compactMap { try? managedContext.fetch($0) }
				//				.flatMap(identity)
					.compactMap { $0 as? NSManagedObject }
					.forEach(managedContext.delete(_:))

				saveChanges(managedContext)
			}
//			do {
//				let breeds = try fetchData()
//				for breed in breeds {
//					try persistentContainer.viewContext.performAndWait {
//						persistentContainer.viewContext.delete(breed)
//						try saveContext()
//					}
//				}
//			} catch {
//				print("Error cleaning DB \(error.localizedDescription)")
//			}
		} delete: { object in
			managedContext.performAndWait {
				managedContext.delete(object)
				saveChanges(managedContext)
			}
		}

	}

	public static func mock() {

	}
}

// private func saveChanges(_ managedContext: NSManagedObjectContext, _ completion: DatabaseCompletion?) {
private func saveChanges(_ managedContext: NSManagedObjectContext) {
	guard managedContext.hasChanges else {
//		completion?(.success(()))
		return
	}

	managedContext.performAndWait {
		do {
			try managedContext.save()
//			completion?(.success(()))
		} catch {
//			completion?(.failure(error))
		}
	}
}

private func fetchObjectsRequest(
	entity: DatabaseEntity,
	sortDescriptors: [NSSortDescriptor]? = nil,
	managedContext: NSManagedObjectContext
	//		completion: @escaping DatabaseObjectsCompletion
) -> [Any] {
	let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)
	//		fetchRequest.sortDescriptors = sortDescriptors

	return managedContext.performAndWait {
		do {
			let objects = try managedContext.fetch(fetchRequest)
			return objects
			//				completion(.success(objects))
		} catch {
			//				completion(.failure(error))
		}
		return []
	}
	}
