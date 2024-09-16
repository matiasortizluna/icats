//
//  NetworkService.swift
//  iCats
//
//  Created by Matias Luna on 10/09/2024.
//

import Foundation

public typealias NetworkServiceResponse = Result<(Data, HTTPURLResponse), Error>

/// Definition of protocol
public protocol NetworkProtocol {
	func call<T : Decodable> (_ endpoint: Endpoint) async throws -> T
}

/// Definition of struct
struct NetworkService : NetworkProtocol{
	// Here is defined the syntax and type of the base network request.
	let baseNetworkRequest : (URLRequest) async throws -> (Data, URLResponse)

	// Here is defined the init method of the Network Service. It assigns the baseNetworkRequest closure with the function/closure/parameter sent as argument.
	init(
		baseNetworkRequest : @escaping (URLRequest) async throws -> (Data, URLResponse))
	{
		self.baseNetworkRequest = baseNetworkRequest
	}

	/// Implementation of the protocol's method
	func call<T>(_ endpoint: Endpoint) async throws -> T where T : Decodable {

		/// Generate URL Request.
		guard let request = try generateURLRequest(endpoint) else {
			throw NetworkError.invalidURL
		}

		/// Trigger URL Request
		let (data, response) = try await baseNetworkRequest(request)

		/// Transform URLResponse as HTTPURLResponse to obtain status code after HTTP Request
		guard let httpResponse = response as? HTTPURLResponse else {
			throw NetworkError.invalidHTTPResponse
		}

		/// Trigger error if HTTP Response status code is <200 and >300
		guard (200..<300).contains(httpResponse.statusCode) else {
			throw NetworkError.serverError(httpResponse.statusCode)
		}

		/// Decode data response after HTTP Request.
		let decoder = JSONDecoder()
		let result = try decoder.decode(T.self, from: data)

		/// Return data response from HTTP Request
		return result
	}

	public static func live() -> NetworkService {
		.init(baseNetworkRequest: { request in
			return try await URLSession.shared.data(for: request)
		})
	}

	public static func mock(mockValueProvider : @escaping () -> NetworkServiceResponse) -> NetworkService {
		.init(
			baseNetworkRequest: { request in
				switch mockValueProvider() {
				case .success(let value) : return value
				case .failure(let error) : throw error
				}

			})
	}
}

private extension String {
	/// Here is the defined string to use as central URL for all network requests
	static var centralURL : Self = "https://api.thecatapi.com"
}

/// Here are defined the helper private functions of the struct.
extension NetworkService {

	/// Method that takes and endpoint and generates the final URL request to be used
	private func generateURLRequest(_ endpoint: Endpoint) throws -> URLRequest? {

		do {
			/// Generates final URL to be used. (URL, Endpoint Path and Query Items)
			let baseURL : URL = try generateFinalURL(endpoint)

			/// Create URL Request with the generated final URL
			var request = URLRequest(url: baseURL)

			/// Define the HTTP Method for each endpoint
			request.httpMethod = endpoint.method.rawValue

			/// Add the default values for headers that every request needs to URL Request.
			let headers : [String : String] = [
				Header.xApiKey.rawValue : HeaderValue.xApiKey.rawValue,
				Header.contentType.rawValue : HeaderValue.contentType.rawValue
			]
			headers.forEach {
				request.addValue($0.value, forHTTPHeaderField: $0.key)
			}

			/// Return URL Request with all neeeded information.
			return request

		} catch NetworkError.invalidURL {
			/// Handle NetworkErrors.invalidURL  errors
			print(NetworkError.invalidURL.localizedDescription)
		}

		return nil
	}

	/// Method that takes and endpoint and generates the final URL request to be used. (URL, Endpoint Path and Query Items)
	private func generateFinalURL(_ endpoint : Endpoint) throws -> URL {

		/// Retrieve constant value of central URL to be used accross all requests.
		guard var baseURL = URL(string: .centralURL) else {
			throw NetworkError.invalidURL
		}

		/// Add to baseURL the API version path to the URL.
		baseURL = baseURL.appendingPathComponent(endpoint.version)

		/// Add to baseURL the endpoint path to the URL.
		baseURL = baseURL.appendingPathComponent(endpoint.path)

		/// If there are no queryItems associated with the endpoint, then return the URL already.
		if (endpoint.queryItems.isEmpty) {
			return baseURL
		}

		/// Create final URL by joinning baseURL with Query Items.
		guard var urlComponents = URLComponents(string: baseURL.absoluteString) else {
			throw NetworkError.invalidURL
		}

		/// Transform from APIQueryItems to URLQueryItems.
		let urlQueryItems : [URLQueryItem] = endpoint.queryItems.map(makeQueryItem(_:))

		/// Create final URL by joinning baseURL with Query Items.
		urlComponents.queryItems = urlQueryItems

		/// Retrieve final URL that contains baseURL.
		guard let finalURL = urlComponents.url else {
			throw NetworkError.invalidURL
		}

		/// Return final URL that contains baseURL.
		return finalURL
	}

	/// Method that transforms APIQueryItems items to URLQueryItems items
	private func makeQueryItem(_ queryItem : APIQueryItem) -> URLQueryItem {
		switch queryItem {
		case let .keyValue(key, value) :
			return .init(name: key, value: value)
		}
	}
}
