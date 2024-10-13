import Foundation

@Observable
class AboutViewModel {
	private let databaseService: DatabaseService

	init(
		databaseService: DatabaseService
	) {
		self.databaseService = databaseService
	}

	func clearDatabaseButtonTapped() {
		do {
			try databaseService.deleteAll([DatabaseEntity.breed, DatabaseEntity.catImage])
		} catch {
			print("Error when clearDatabaseButtonTapped() \(error.localizedDescription)")
		}
	}
}
