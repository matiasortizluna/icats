//
//  ImagesNetworkService.swift
//  iCats
//
//  Created by Matias Luna on 12/09/2024.
//

import Foundation

typealias ImageID = String

struct ImagesNetworkService {
	var fetchImage : (ImageID) async throws -> CatImageData

	public static func live (baseNetworkService : BaseNetworkService) -> Self {
		.init(fetchImage: { id in
			let result : CatImageData = try await baseNetworkService.call(.images(id))
			return result
		})
	}

	static func mock() -> Self {
		.init(fetchImage: { _ in
			fatalError("Unimplemented submit closure")
		})
	}

}
