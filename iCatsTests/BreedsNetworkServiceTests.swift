import XCTest
@testable import iCats

final class BreedsNetworkServiceTests: XCTestCase {
	func testFetchBreeds_ShouldReturnSuccess() async throws {
		let mockData = try XCTUnwrap(BreedsNetworkServiceRequestSuccessMock.success.data(using: .utf8))

		let mockResponse = NetworkServiceResponse.mock(
			data: mockData,
			status: 200
		)

		let networkService  = NetworkService.mock(mockValueProvider: { mockResponse })

		let sut = BreedsNetworkService.live(networkService: networkService)

		do {
			let response = try await sut.fetchBreeds()
			XCTAssertEqual(response, [BreedsData].breedsMock)

		} catch {
			XCTFail("Expected Data Conversion to [BreedsData] failed")
		}
	}

	func testFetchBreeds_ShouldReturnError() async throws {
		let mockData = try XCTUnwrap(BreedsNetworkServiceRequestSuccessMock.success.data(using: .utf8))

		let mockResponse = NetworkServiceResponse.mock(
			data: mockData,
			status: 500
		)

		let networkService  = NetworkService.mock(mockValueProvider: { mockResponse })

		let sut = BreedsNetworkService.live(networkService: networkService)

		do {
			let response : [BreedsData] = try await sut.fetchBreeds()
			print(response)
			XCTFail("This service call should throw an error instead.")

		} catch {
			let networkError = try XCTUnwrap(error as? NetworkError)
			XCTAssertEqual(networkError, .serverError(500))
		}
	}

}
