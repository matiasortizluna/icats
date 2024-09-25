//
//  Endpoint.swift
//  iCats
//
//  Created by Matias Luna on 10/09/2024.
//

import Foundation
import CoreFoundation

public enum Endpoint {
	// TODO: could you remove this space?
	case images(String)
	case breeds(Int, Int)

	// TODO: could you remove the spaces between the name and the colon : here and in the other lines here in this file?
	var method : HTTPMethod {
		switch self {
		case .images : .get
		case .breeds : .get
		}
	}

	// TODO: could you add these strings to a private String extension in this file?
	// Note that these are not user readable, so they are typically not used in views (shared).
	// Therefore, the extension can be private
	var version : String {
		"v1"
	}

	var path : String {
		switch self {
		case .images(let id) : return "images/\(id)"
		case .breeds : return "breeds"
		}
	}

	var queryItems : [APIQueryItem] {
		switch self {
		case .images : return []
		case .breeds(let limit, let page) : return [.keyValue(key: "limit", value: String(limit)), .keyValue(key: "page", value: String(page))]
		}
	}
}

enum HTTPMethod: String {
	case get = "GET"
	case post = "POST"
	case put = "PUT"
	case patch = "PATCH"
	case delete = "DELETE"
}

enum NetworkError : Error, Equatable {
	case serverError(Int)
	case authenticationFailure
	case unhandledHTTPStatus(Int)
	case invalidHTTPResponse
	case invalidURL
	case dataConversionFailure
}

enum APIQueryItem {
	case keyValue(key: String, value: String)
}

enum Header : String {
	case xApiKey = "x-api-key"
	case contentType = "Content-Type"
}

enum HeaderValue : String {
	// TODO: could you remove this space?
	case xApiKey
	case contentType

	var rawValue: String {
		switch self {
		case .contentType : "application/json"
		case .xApiKey : "live_ISll8gOWarTBCiBssIqrzkvhzuez2g72xz4WzKx1BkRLXoWIlXD1GTKNklz1ERUr"
		}
	}
}
