//
//  NetworkService.swift
//  iCats
//
//  Created by Matias Luna on 12/09/2024.
//

import Foundation

struct BreedsNetworkService {
	var fetchBreeds : (_ limit: Int, _ page: Int) async throws -> [BreedsData]

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
}
