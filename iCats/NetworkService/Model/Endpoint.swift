//
//  Endpoint.swift
//  iCats
//
//  Created by Matias Luna on 10/09/2024.
//

import Foundation
import CoreFoundation

public enum Endpoint {

	case images(String)
	case breeds(Int, Int)

	var method : HTTPMethod {
		switch self {
		case .images : .get
		case .breeds : .get
		}
	}

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

	case xApiKey
	case contentType

	var rawValue: String {
		switch self {
		case .contentType : "application/json"
		case .xApiKey : "live_ISll8gOWarTBCiBssIqrzkvhzuez2g72xz4WzKx1BkRLXoWIlXD1GTKNklz1ERUr"
		}
	}
}
