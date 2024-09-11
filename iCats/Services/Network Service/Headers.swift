//
//  Headers.swift
//  iCats
//
//  Created by Matias Luna on 10/09/2024.
//

import Foundation

enum Headers : String {
	case xApiKey = "x-api-key"
	case contentType = "Content-Type"
}

enum HeadersValues : String {

	case xApiKey
	case contentType

	var rawValue: String {
		switch self {
		case .contentType : "application/json"
		case .xApiKey : "live_ISll8gOWarTBCiBssIqrzkvhzuez2g72xz4WzKx1BkRLXoWIlXD1GTKNklz1ERUr"
		}
	}
}
