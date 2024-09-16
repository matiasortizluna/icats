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
			XCTFail("This service call should throw an error instead.")

		} catch {
			let networkError = try XCTUnwrap(error as? NetworkError)
			XCTAssertEqual(networkError, .serverError(500))
		}
	}

}

extension [BreedsData] {
	static var breedsMock : Self = [
		BreedsData(
			weight: WeightData(
				imperial: "7  -  10",
				metric: "3 - 5"
			),
			id: "abys",
			name: "Abyssinian",
			temperament: "Active, Energetic, Independent, Intelligent, Gentle",
			origin: "Egypt",
			description: "The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.",
			lifeSpan: "14 - 15",
			referenceImageID: "0XYvRd7oD",
			image: CatImageData(
				id: "0XYvRd7oD",
				width: 1204,
				height: 1445,
				url: "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg"
			)
		),
		BreedsData(
			weight: WeightData(
				imperial: "7 - 10",
				metric: "3 - 5"
			),
			id: "aege",
			name: "Aegean",
			temperament: "Affectionate, Social, Intelligent, Playful, Active",
			origin: "Greece",
			description: "Native to the Greek islands known as the Cyclades in the Aegean Sea, these are natural cats, meaning they developed without humans getting involved in their breeding. As a breed, Aegean Cats are rare, although they are numerous on their home islands. They are generally friendly toward people and can be excellent cats for families with children.",
			lifeSpan: "9 - 12",
			referenceImageID: "ozEvzdVM-",
			image: CatImageData(
				id: "ozEvzdVM-",
				width: 1200,
				height: 800,
				url: "https://cdn2.thecatapi.com/images/ozEvzdVM-.jpg"
			)
		),
		BreedsData(
			weight: WeightData(
				imperial: "6 - 15",
				metric: "3 - 7"
			),
			id: "char",
			name: "Chartreux",
			temperament: "Affectionate, Loyal, Intelligent, Social, Lively, Playful",
			origin: "France",
			description: "The Chartreux is generally silent but communicative. Short play sessions, mixed with naps and meals are their perfect day. Whilst appreciating any attention you give them, they are not demanding, content instead to follow you around devotedly, sleep on your bed and snuggle with you if you’re not feeling well.",
			lifeSpan: "12 - 15",
			referenceImageID: "j6oFGLpRG",
			image: CatImageData(
				id: "j6oFGLpRG",
				width: 768,
				height: 1024,
				url: "https://cdn2.thecatapi.com/images/j6oFGLpRG.jpg"
			)
		)
	]
}
