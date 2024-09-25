import XCTest
@testable import iCats

class BreedsListViewModelTests: XCTestCase {

	func testFetchMoreContent_ShouldReturnMoreContent() async throws {

		let networkService  = NetworkService.live()

		let breedsListNetworkService = BreedsListNetworkService.live(networkService: networkService)

		let sut = await BreedsListViewModel(breedsNetworkService: breedsListNetworkService)

		var breedsCount = await sut.breeds.count
		XCTAssertEqual(breedsCount, 0)

		try await sut.viewAppeared()

		breedsCount = await sut.breeds.count
		XCTAssertTrue(breedsCount > 0)
	}

	func testBottomReached_ShouldReturnMoreContent() async throws {

		let networkService  = NetworkService.live()

		let breedsListNetworkService = BreedsListNetworkService.live(networkService: networkService)

		let sut = await BreedsListViewModel(breedsNetworkService: breedsListNetworkService)
		
		try await sut.viewAppeared()

		let breedsCountBefore = await sut.breeds.count

		try await sut.viewAppeared()

		let breedsCountAfter = await sut.breeds.count

		XCTAssertTrue(breedsCountBefore < breedsCountAfter)
	}
}
