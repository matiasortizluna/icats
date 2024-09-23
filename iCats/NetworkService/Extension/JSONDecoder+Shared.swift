//
//  Decoder.swift
//  iCats
//
//  Created by Matias Luna on 11/09/2024.
//

import Foundation

extension JSONDecoder {
	/// A shared instance of JSONDecoder for decode JSON data Swift types.
	///
	/// Usage:
	/// ```
	/// let decoder = JSONDecoder.shared
	/// let jsonData = try decoder.decode(someDecodableValue)
	/// ```
	public static let shared: JSONDecoder = { .init() }()
}
