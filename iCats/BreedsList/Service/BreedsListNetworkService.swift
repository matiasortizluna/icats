import Foundation

struct BreedsListNetworkService {
	// TODO: could you remove the spaces between the name and the colon : ?
	// Here and other places in the app
	var fetchBreeds : (_ limit: Int, _ page: Int) async throws -> [BreedJSON]

	static func live(networkService: NetworkService) -> Self {
		.init(
			fetchBreeds: { limit, page in
				try await networkService.call(.breeds(limit, page))
			}
		)
	}

	static func mock(networkService: NetworkService, response : NetworkServiceResponse) -> Self {
		.init(
			fetchBreeds: { _, _ in
				fatalError("Unimplemented submit closure")
			}
		)
	}

	static func mockPreview() -> Self {
		.init(
			fetchBreeds: { _, _ in
				return [BreedJSON].breedsMock
			}
		)
	}
}
