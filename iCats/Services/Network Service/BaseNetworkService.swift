//
//  NetworkService.swift
//  iCats
//
//  Created by Matias Luna on 10/09/2024.
//

import Foundation

/// Definition of protocol
public protocol BaseNetworkProtocol {
	func call<T : Decodable> (_ endpoint: Endpoints) async throws -> T
}

/// Definition of struct
struct BaseNetworkService : BaseNetworkProtocol{

	/// Implementation of the protocol's method
	func call<T>(_ endpoint: Endpoints) async throws -> T where T : Decodable {
		
		/// Generate URL Request.
		guard let request = try generateURLRequest(endpoint) else {
			throw NetworkErrors.invalidURL
		}

		/// Trigger URL Request
		let (data, response) = try await baseNetworkRequest(request)

		/// Transform URLResponse as HTTPURLResponse to obtain status code after HTTP Request
		guard let httpResponse = response as? HTTPURLResponse else {
			throw NetworkErrors.invalidHTTPResponse
		}

		/// Trigger error if HTTP Response status code is <200 and >300
		guard (200..<300).contains(httpResponse.statusCode) else {
			throw NetworkErrors.serverError(httpResponse.statusCode)
		}

		/// Decode data response after HTTP Request.
		let decoder = JSONDecoder()
		let result = try decoder.decode(T.self, from: data)
		
		/// Return data response from HTTP Request
		return result
	}

	/// Here is defined the syntax and type of the base network request.
	let baseNetworkRequest : (URLRequest) async throws -> (Data, URLResponse)

	/// Here is defined the init method of the Network Service. It assigns the baseNetworkRequest closure with the function/closure/parameter sent as argument.
	init(
		baseNetworkRequest : @escaping (URLRequest) async throws -> (Data, URLResponse))
	{
		self.baseNetworkRequest = baseNetworkRequest
	}
}

private extension String {
	/// Here is the defined string to use as central URL for all network requests
	static var centralURL : Self = "https://api.thecatapi.com"
}

extension BaseNetworkService {
	/// Here are defined the helper private functions of the struct.

	/// Method that takes and endpoint and generates the final URL request to be used
	private func generateURLRequest(_ endpoint: Endpoints) throws -> URLRequest? {

		do {
			/// Generates final URL to be used. (URL, Endpoint Path and Query Items)
			let baseURL : URL = try generateFinalURL(endpoint)

			/// Create URL Request with the generated final URL
			var request = URLRequest(url: baseURL)

			/// Define the HTTP Method for each endpoint
			request.httpMethod = endpoint.method.rawValue

			/// Add the default values for headers that every request needs to URL Request.
			let headers : [String : String] = [
				Headers.xApiKey.rawValue : HeadersValues.xApiKey.rawValue,
				Headers.contentType.rawValue : HeadersValues.contentType.rawValue
			]
			headers.forEach {
				request.addValue($0.value, forHTTPHeaderField: $0.key)
			}

			/// Return URL Request with all neeeded information.
			return request

		} catch NetworkErrors.invalidURL {
			/// Handle NetworkErrors.invalidURL  errors
			print(NetworkErrors.invalidURL.localizedDescription)
		}

		return nil
	}

	/// Method that takes and endpoint and generates the final URL request to be used. (URL, Endpoint Path and Query Items)
	private func generateFinalURL(_ endpoint : Endpoints) throws -> URL {

		/// Retrieve constant value of central URL to be used accross all requests.
		guard var baseURL = URL(string: .centralURL) else {
			throw NetworkErrors.invalidURL
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
			throw NetworkErrors.invalidURL
		}

		/// Transform from APIQueryItems to URLQueryItems.
		let urlQueryItems : [URLQueryItem] = endpoint.queryItems.map(makeQueryItem(_:))

		/// Create final URL by joinning baseURL with Query Items.
		urlComponents.queryItems = urlQueryItems

		/// Retrieve final URL that contains baseURL.
		guard let finalURL = urlComponents.url else {
			throw NetworkErrors.invalidURL
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
