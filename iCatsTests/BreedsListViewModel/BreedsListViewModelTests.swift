import XCTest
import IdentifiedCollections
@testable import iCats

class BreedsListViewModelTests: XCTestCase {
	func testOnViewAppeared_WhenSucceeds_ShouldFetchAndUpdateBreeds() async throws {
		let sut = BreedsListViewModel(breedsNetworkService: .mock())

		await sut.onViewAppeared()

		XCTAssertEqual(sut.filteredBreeds, IdentifiedArrayOf<BreedModel>.expectedBreeds)
	}

	func testOnViewAppeared_WhenFails_ShouldShowAlert() async throws {
		let sut = BreedsListViewModel(breedsNetworkService: .mockError())

		await sut.onViewAppeared()

		// XCTAssertEqual(sut.destination, .alert<>)
		XCTAssertTrue(sut.filteredBreeds.isEmpty)
	}

//
//	func testFetchMoreContent_ShouldReturnMoreContent() async throws {
//
//		let networkService  = NetworkService.live()
//
//		let breedsListNetworkService = BreedsListNetworkService.live(networkService: networkService)
//
//		let sut = BreedsListViewModel(breedsNetworkService: breedsListNetworkService)
//
//		var breedsCount = sut.filteredBreeds.count
//		XCTAssertEqual(breedsCount, 0)
//
//		try await sut.onViewAppeared()
//
//		breedsCount = sut.filteredBreeds.count
//		XCTAssertTrue(breedsCount > 0)
//	}
//
//	func testBottomReached_ShouldReturnMoreContent() async throws {
//
//		let networkService  = NetworkService.live()
//
//		let breedsListNetworkService = BreedsListNetworkService.live(networkService: networkService)
//
//		let sut = BreedsListViewModel(breedsNetworkService: breedsListNetworkService)
//		
//		try await sut.onViewAppeared()
//
//		let breedsCountBefore = sut.filteredBreeds.count
//
//		try await sut.onViewAppeared()
//
//		let breedsCountAfter = sut.filteredBreeds.count
//
//		XCTAssertTrue(breedsCountBefore < breedsCountAfter)
//	}
}

extension IdentifiedArrayOf<BreedModel> {
	static let expectedBreeds: Self = [
		BreedModel(
			id: "abys",
			name: "Abyssinian",
			origin: "Egypt",
			temperament: "Active, Energetic, Independent, Intelligent, Gentle",
			breedDescription: "The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.",
			lifeSpan: LifespanModel(
				upperValue: 15,
				lowerValue: 14
			),
			image: CatImageModel(
				id: "0XYvRd7oD",
				width: 1204,
				height: 1445,
				url: "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg"
			)
		),
		BreedModel(
			id: "aege",
			name: "Aegean",
			origin: "CountryName",
			temperament: "Active, Energetic, Independent, Intelligent, Gentle",
			breedDescription: "The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.",
			lifeSpan: LifespanModel(
				upperValue: 20,
				lowerValue: 10
			),
			image: CatImageModel(
				id: "0XYvRd7oD",
				width: 1204,
				height: 1445,
				url: "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg"
			)
		)
	]
}
