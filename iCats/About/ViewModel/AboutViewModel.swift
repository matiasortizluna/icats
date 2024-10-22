import Foundation

@Observable
class AboutViewModel {
	private let databaseService: DatabaseService

	init(databaseService: DatabaseService) {
		self.databaseService = databaseService
	}

	func clearDatabaseButtonTapped() async {
		try? await databaseService.deleteObjects(DatabaseEntity.breed)
	}
}
