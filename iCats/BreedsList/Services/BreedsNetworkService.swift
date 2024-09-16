//
//  NetworkService.swift
//  iCats
//
//  Created by Matias Luna on 12/09/2024.
//

import Foundation

struct BreedsNetworkService {
	var fetchBreeds : () async throws -> [BreedsData]
	
	static func live(networkService: NetworkService) -> Self {
		.init(
			fetchBreeds: {
				try await networkService.call(.breeds)
			}
		)
	}
	
	static func mock(networkService: NetworkService, response : NetworkServiceResponse) -> Self {
		.init(
			fetchBreeds: {
				fatalError("Unimplemented submit closure")
			}
		)
	}
}
