import Foundation
import CoreData

public struct DatabaseService {
	public let fetchObjects: (_ entity: DatabaseEntity, _ sort: [NSSortDescriptor]?) async throws -> [Any]
	public let createObject: (_ entity: DatabaseEntity) async throws -> Any
	public let save: () async throws -> Void
	public let deleteAll: (_ entities: [DatabaseEntity]) async throws -> Void
	public let count: (_ entity: DatabaseEntity) async throws -> Int
}

extension DatabaseService {
	public static func liveContainer(_ persistentContainerName: String) -> NSPersistentContainer {
		let persitentContainer = NSPersistentContainer(name: persistentContainerName)
		initializePersistentContainer(persistentContainer: persitentContainer)
		return persitentContainer
	}

	public static func mockContainer(_ persistentContainerName: String) -> NSPersistentContainer {
		let persitentContainer = NSPersistentContainer(name: persistentContainerName)
		let description = NSPersistentStoreDescription(url: URL(fileURLWithPath: "/dev/null"))
		persitentContainer.persistentStoreDescriptions = [description]
		initializePersistentContainer(persistentContainer: persitentContainer)
		return persitentContainer
	}

	private static func initializePersistentContainer(persistentContainer: NSPersistentContainer) {
		persistentContainer.loadPersistentStores { _, error in
			if let error {
				fatalError("Failed to load persistent stores: \(error.localizedDescription)")
			}
		}
	}

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
			try managedContext.performAndWait {
				guard let entity = NSEntityDescription.entity(forEntityName: entity.rawValue, in: managedContext) else {
					throw DatabaseServiceError.noEntity
				}
				return NSManagedObject(entity: entity, insertInto: managedContext)
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
					.flatMap(identity)
					.compactMap { $0 as? NSManagedObject }
					.forEach(managedContext.delete(_:))
				saveChanges(managedContext)
			}
		} count: { entity in
			try managedContext.performAndWait {
				return try managedContext.count(for: NSFetchRequest(entityName: entity.rawValue))
			}
		}
	}

	public static func mock(persistentContainer: NSPersistentContainer = mockContainer("iCats")) -> Self {
		// TODO: Implement Mocks
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
					return object
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
					.compactMap { $0 as? NSManagedObject }
					.forEach(managedContext.delete(_:))

				saveChanges(managedContext)
			}
		} count: { entity in
			try managedContext.performAndWait {
				return try managedContext.count(for: NSFetchRequest(entityName: entity.rawValue))
			}
		}
	}
}

private func saveChanges(_ managedContext: NSManagedObjectContext) {
	guard managedContext.hasChanges else {
		return
	}

	managedContext.performAndWait {
		do {
			try managedContext.save()
		} catch {
			print("Error managedContext.save() \(error.localizedDescription)")
		}
	}
}

private func fetchObjectsRequest(
	entity: DatabaseEntity,
	sortDescriptors: [NSSortDescriptor]? = nil,
	managedContext: NSManagedObjectContext
) -> [Any] {
	let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)

	return managedContext.performAndWait {
		do {
			let objects = try managedContext.fetch(fetchRequest)
			return objects
		} catch {
			print("Error managedContext.fetch(fetchRequest) \(error.localizedDescription)")
		}
		return []
	}
}

public func identity<A>(_ a: A) -> A { a }  // swiftlint:disable:this identifier_name
