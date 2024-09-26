import XCTest
@testable import iCats

class BreedsListViewModelTests: XCTestCase {

	func testFetchMoreContent_ShouldReturnMoreContent() async throws {

		let networkService  = NetworkService.live()

		let breedsListNetworkService = BreedsListNetworkService.live(networkService: networkService)

		let sut = BreedsListViewModel(breedsNetworkService: breedsListNetworkService)

		var breedsCount = sut.filteredBreeds.count
		XCTAssertEqual(breedsCount, 0)

		try await sut.viewAppeared()

		breedsCount = sut.filteredBreeds.count
		XCTAssertTrue(breedsCount > 0)
	}

	func testBottomReached_ShouldReturnMoreContent() async throws {

		let networkService  = NetworkService.live()

		let breedsListNetworkService = BreedsListNetworkService.live(networkService: networkService)

		let sut = BreedsListViewModel(breedsNetworkService: breedsListNetworkService)
		
		try await sut.viewAppeared()

		let breedsCountBefore = sut.filteredBreeds.count

		try await sut.viewAppeared()

		let breedsCountAfter = sut.filteredBreeds.count

		XCTAssertTrue(breedsCountBefore < breedsCountAfter)
	}

	
}
