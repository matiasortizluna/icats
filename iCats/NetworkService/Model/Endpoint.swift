import Foundation
import CoreFoundation

private extension String {
	static let version: Self = "v1"
	static let breedsPath: Self = "breeds"
	static let limit: Self = "limit"
	static let page: Self = "page"
}

public enum Endpoint {
	case images(String)
	case breeds(Int, Int)

	var method: HTTPMethod {
		switch self {
		case .images: .get
		case .breeds: .get
		}
	}

	var version: String {
		.version
	}

	var path: String {
		switch self {
		case .images(let id): return "images/\(id)"
		case .breeds: return .breedsPath
		}
	}

	var queryItems: [APIQueryItem] {
		switch self {
		case .images: return []
		case .breeds(let limit, let page): return [.keyValue(key: .limit, value: String(limit)), .keyValue(key: String.page, value: String(page))]
		}
	}
}

private extension String {
	static let get: Self = "GET"
	static let post: Self = "POST"
	static let put: Self = "PUT"
	static let patch: Self = "PATCH"
	static let delete: Self = "DELETE"
}

enum HTTPMethod: String {
	case get = "GET"
	case post = "POST"
	case put = "PUT"
	case patch = "PATCH"
	case delete = "DELETE"
}

enum NetworkError: Error, Equatable {
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

private extension String {
	static let xApiKey: Self = "x-api-key"
	static let contentType: Self = "Content-Type"
}

enum Header: String {
	case xApiKey = "x-api-key"
	case contentType = "Content-Type"
}

private extension String {
	static let headerContentType: Self = "application/json"
	static let headerXApiKey: Self = "live_ISll8gOWarTBCiBssIqrzkvhzuez2g72xz4WzKx1BkRLXoWIlXD1GTKNklz1ERUr"
}

enum HeaderValue: String {
	case xApiKey
	case contentType

	var rawValue: String {
		switch self {
		case .contentType: .headerContentType
		case .xApiKey: .headerXApiKey
		}
	}
}
