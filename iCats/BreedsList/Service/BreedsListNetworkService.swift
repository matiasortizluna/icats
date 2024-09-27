import Foundation

struct BreedsListNetworkService {
	var fetchBreeds: (_ limit: Int, _ page: Int) async throws -> [Breed]

	static func live(networkService: NetworkService) -> Self {
		.init(
			fetchBreeds: { limit, page in
				try await networkService.call(.breeds(limit, page))
			}
		)
	}

	static func mock() -> Self {
		.init(
			fetchBreeds: { _, _ in return [Breed].breedsMock }
		)
	}

	static func mockError() -> Self {
		.init(
			fetchBreeds: { _, _ in throw NetworkError.serverError(503) }
		)
	}

	static func notImplementedMock() -> Self {
		.init(
			fetchBreeds: { _, _ in return fatalError("Unimplemented submit closure") }
		)
	}
}
