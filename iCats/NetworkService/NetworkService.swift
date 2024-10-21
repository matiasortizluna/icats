import Foundation

public typealias NetworkServiceResponse = Result<(Data, HTTPURLResponse), Error>

public protocol NetworkProtocol {
	func call<T: Decodable> (_ endpoint: Endpoint) async throws -> T
}

struct NetworkService: NetworkProtocol{
	let baseNetworkRequest: (URLRequest) async throws -> (Data, URLResponse)

	init(
		baseNetworkRequest: @escaping (URLRequest) async throws -> (Data, URLResponse))
	{
		self.baseNetworkRequest = baseNetworkRequest
	}

	func call<T>(_ endpoint: Endpoint) async throws -> T where T: Decodable {
		guard let request = try generateURLRequest(endpoint) else {
			throw NetworkError.invalidURL
		}

		let (data, response) = try await baseNetworkRequest(request)

		guard let httpResponse = response as? HTTPURLResponse else {
			throw NetworkError.invalidHTTPResponse
		}

		guard (200..<300).contains(httpResponse.statusCode) else {
			throw NetworkError.serverError(httpResponse.statusCode)
		}

		let decoder = JSONDecoder()
		let result = try decoder.decode(T.self, from: data)

		return result
	}

	public static func live() -> NetworkService {
		.init(baseNetworkRequest: { request in
			return try await URLSession.shared.data(for: request)
		})
	}

	public static func mock(mockValueProvider: @escaping () -> NetworkServiceResponse) -> NetworkService {
		.init(
			baseNetworkRequest: { _ in
				switch mockValueProvider() {
				case .success(let value): return value
				case .failure(let error): throw error
				}

			})
	}
}

private extension String {
	static var centralURL: Self = "https://api.thecatapi.com"
}

extension NetworkService {
	private func generateURLRequest(_ endpoint: Endpoint) throws -> URLRequest? {
		do {
			let baseURL: URL = try generateFinalURL(endpoint)

			var request = URLRequest(url: baseURL)

			request.httpMethod = endpoint.method.rawValue

			let headers: [String: String] = [
				Header.xApiKey.rawValue: HeaderValue.xApiKey.rawValue,
				Header.contentType.rawValue: HeaderValue.contentType.rawValue
			]
			headers.forEach {
				request.addValue($0.value, forHTTPHeaderField: $0.key)
			}

			return request

		} catch NetworkError.invalidURL {
			assertionFailure(NetworkError.invalidURL.localizedDescription)
		}

		return nil
	}

	private func generateFinalURL(_ endpoint: Endpoint) throws -> URL {
		guard var baseURL = URL(string: .centralURL) else {
			throw NetworkError.invalidURL
		}

		baseURL = baseURL.appendingPathComponent(endpoint.version)

		baseURL = baseURL.appendingPathComponent(endpoint.path)

		if endpoint.queryItems.isEmpty {
			return baseURL
		}

		guard var urlComponents = URLComponents(string: baseURL.absoluteString) else {
			throw NetworkError.invalidURL
		}

		let urlQueryItems: [URLQueryItem] = endpoint.queryItems.map(makeQueryItem(_:))

		urlComponents.queryItems = urlQueryItems

		guard let finalURL = urlComponents.url else {
			throw NetworkError.invalidURL
		}

		return finalURL
	}

	private func makeQueryItem(_ queryItem: APIQueryItem) -> URLQueryItem {
		switch queryItem {
		case let .keyValue(key, value) :
			return .init(name: key, value: value)
		}
	}
}
