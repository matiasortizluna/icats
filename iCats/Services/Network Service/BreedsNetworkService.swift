//
//  NetworkService.swift
//  iCats
//
//  Created by Matias Luna on 12/09/2024.
//

import Foundation

struct BreedsNetworkService {
	var fetchBreeds : () async throws -> BreedsData

	static func live(baseNetworkService: BaseNetworkService) -> Self {
		.init(
			fetchBreeds: {
				let result : BreedsData = try await baseNetworkService.call(.breeds)
				return result
			}
		)
	}

	static func mock() -> Self {
		.init(
			fetchBreeds: { 
				fatalError("Unimplemented submit closure")
			}
		)
	}

}
