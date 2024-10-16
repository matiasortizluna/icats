import Foundation

struct BreedsListNetworkService {
	var fetch: (_ limit: Int, _ page: Int) async throws -> [Breed]

	static func live(networkService: NetworkService) -> Self {
		.init(
			fetch: { limit, page in
				try await networkService.call(.breeds(limit, page))
			}
		)
	}

	static func mock() -> Self {
		.init(
			fetch: { _, _ in return [Breed].breedsMock }
		)
	}

	static func mockError() -> Self {
		.init(
			fetch: { _, _ in throw NetworkError.serverError(503) }
		)
	}

	static func notImplementedMock() -> Self {
		.init(
			fetch: { _, _ in return fatalError("Unimplemented submit closure") }
		)
	}
}
