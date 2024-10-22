import Foundation
import CoreData

public struct DatabaseService {
	public let fetchObjects: (_ entity: DatabaseEntity, _ sort: [NSSortDescriptor]?) async throws -> [Any]
	public let createObject: (_ entity: DatabaseEntity) async throws -> Any
	public let save: () async throws -> Void
	public let deleteObjects: (_ entity: DatabaseEntity) async throws -> Void
	public let deleteAllOf: (_ entities: [DatabaseEntity]) async -> Void
	public let count: (_ entity: DatabaseEntity) async throws -> Int
	let newBackgroundContext: () async throws -> NSManagedObjectContext
}

extension DatabaseService {
	public static func liveContainer(_ persistentContainerName: String) -> NSPersistentContainer {
		let persitentContainer = NSPersistentContainer(name: persistentContainerName)
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
		let managedContext: NSManagedObjectContext = persistentContainer.newBackgroundContext()

		return .init { entity, sortDescriptors in
			managedContext.performAndWait {
				fetchObjectsRequest(
					entity: entity,
					sortDescriptors: sortDescriptors,
					managedContext: managedContext
				)
			}
		} createObject: { entity in
			try managedContext.performAndWait {
				guard
					let entity = NSEntityDescription.entity(forEntityName: entity.rawValue, in: managedContext),
					let newObject = NSManagedObject(entity: entity, insertInto: managedContext) as? Any
				else { throw DatabaseServiceError.noEntity }
				return newObject
			}
		} save: {
			managedContext.performAndWait { saveChanges(managedContext) }
		} deleteObjects: { entity in
			managedContext.performAndWait {
				let objects = fetchObjectsRequest(entity: entity, managedContext: managedContext)
				for case let object as NSManagedObject in objects {
					managedContext.delete(object)
				}
				saveChanges(managedContext)
			}
		} deleteAllOf: { entities in
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
			try managedContext.performAndWait { try managedContext.count(for: NSFetchRequest(entityName: entity.rawValue)) }
		} newBackgroundContext: {
			persistentContainer.newBackgroundContext()
		}
	}
//
//	public static func mockContainer(_ persistentContainerName: String) -> NSPersistentContainer {
//		let persitentContainer = NSPersistentContainer(name: persistentContainerName)
//		let description = NSPersistentStoreDescription(url: URL(fileURLWithPath: "/dev/null"))
//		persitentContainer.persistentStoreDescriptions = [description]
//		initializePersistentContainer(persistentContainer: persitentContainer)
//		return persitentContainer
//	}
//
//	public static func mock(persistentContainer: NSPersistentContainer = mockContainer("iCats")) -> Self {
//		// TODO: Implement Mocks
//		let managedContext: NSManagedObjectContext = persistentContainer.newBackgroundContext()
//
//		return .init { entity, sortDescriptors in
//			managedContext.performAndWait {
//				fetchObjectsRequest(
//					entity: entity,
//					sortDescriptors: sortDescriptors,
//					managedContext: managedContext
//				)
//			}
//		} createObject: { entity in
//			try managedContext.performAndWait {
//				guard
//					let entity = NSEntityDescription.entity(forEntityName: entity.rawValue, in: managedContext),
//					let newObject = NSManagedObject(entity: entity, insertInto: managedContext) as? Any
//				else { throw DatabaseServiceError.noEntity }
//				return newObject
//			}
//		} save: {
//			managedContext.performAndWait { saveChanges(managedContext) }
//		} deleteObjects: { entity in
//			managedContext.performAndWait {
//				let objects = fetchObjectsRequest(entity: entity, managedContext: managedContext)
//				for case let object as NSManagedObject in objects {
//					managedContext.delete(object)
//				}
//				saveChanges(managedContext)
//			}
//		} deleteAllOf: { entities in
//			managedContext.performAndWait {
//				entities
//					.map(\.rawValue)
//					.map(NSFetchRequest<NSFetchRequestResult>.init(entityName:))
//					.map {
//						$0.includesPropertyValues = false
//						return $0
//					}
//					.compactMap { try? managedContext.fetch($0) }
//					.flatMap(identity)
//					.compactMap { $0 as? NSManagedObject }
//					.forEach(managedContext.delete(_:))
//				saveChanges(managedContext)
//			}
//		} count: { entity in
//			try managedContext.performAndWait { try managedContext.count(for: NSFetchRequest(entityName: entity.rawValue)) }
//		} newBackgroundContext: {
//			persistentContainer.newBackgroundContext()
//		}
//	}
}

private func saveChanges(_ managedContext: NSManagedObjectContext) {
	guard managedContext.hasChanges else { return }
	do {
		try managedContext.save()
	} catch {
		assertionFailure("1st: Error managedContext.save() \(error) \(error.localizedDescription)")
	}
}

private func fetchObjectsRequest(
	entity: DatabaseEntity,
	sortDescriptors: [NSSortDescriptor]? = nil,
	managedContext: NSManagedObjectContext
) -> [Any] {
	let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)
	fetchRequest.sortDescriptors = sortDescriptors

	do {
		let objects = try managedContext.fetch(fetchRequest)
		return objects
	} catch {
		assertionFailure("Error managedContext.fetch(fetchRequest) \(error.localizedDescription)")
	}
	return []
}

public func identity<A>(_ a: A) -> A { a }  // swiftlint:disable:this identifier_name
