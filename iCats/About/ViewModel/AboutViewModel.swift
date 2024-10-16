import Foundation

@Observable
class AboutViewModel {
	private let databaseService: DatabaseService

	init(
		databaseService: DatabaseService
	) {
		self.databaseService = databaseService
	}

	@MainActor
	func clearDatabaseButtonTapped() async throws {
		do {
			try await databaseService.deleteAll([DatabaseEntity.breed, DatabaseEntity.catImage])
		} catch {
			print("Error when clearDatabaseButtonTapped() \(error.localizedDescription)")
		}
	}
}
