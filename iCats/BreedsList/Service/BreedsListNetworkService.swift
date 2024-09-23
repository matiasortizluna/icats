import Foundation

struct BreedsListNetworkService {
	var fetchBreeds : (_ limit: Int, _ page: Int) async throws -> [BreedAPI]

	static func live(networkService: NetworkService) -> Self {
		.init(
			fetchBreeds: { limit, page in
				try await networkService.call(.breeds(limit, page))
			}
		)
	}
	
	static func mock(networkService: NetworkService, response : NetworkServiceResponse) -> Self {
		.init(
			fetchBreeds: { limit, page in
				fatalError("Unimplemented submit closure")
			}
		)
	}

	static func mockPreview() -> Self {
		.init(
			fetchBreeds: { limit, page in
				return [BreedAPI].breedsMock
			}
		)
	}
}
