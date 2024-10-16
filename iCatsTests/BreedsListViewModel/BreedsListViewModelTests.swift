import XCTest
import IdentifiedCollections
import SwiftNavigation
import SwiftUINavigation
@testable import iCats

class BreedsListViewModelTests: XCTestCase {
	func testInit() {
		let sut = BreedsListViewModel(
			breedsNetworkService: .mock(),
			databaseService: .mock()
		)
		XCTAssertTrue(sut.filteredBreeds.isEmpty)
		XCTAssertTrue(sut.searchQuery.isEmpty)
	}

	func testOnViewAppeared_WhenSucceeds_ShouldFetchAndUpdateBreeds() async throws {
		let sut = BreedsListViewModel(
			breedsNetworkService: .mock(),
			databaseService: .mock()
		)

		await sut.onViewAppeared()
		XCTAssertEqual(sut.filteredBreeds, .expectedBreeds)
	}

	func testOnViewAppeared_WhenFails_ShouldShowAlert() async throws {
		let sut = BreedsListViewModel(
			breedsNetworkService: .mockError(),
			databaseService: .mock()
		)
		await sut.onViewAppeared()

		XCTAssertEqual(sut.destination, .alert(.alertRetryFetchDynamic(addCancelButton: false)))
		XCTAssertTrue(sut.filteredBreeds.isEmpty)
	}

	func testFilteredBreeds_ShouldShowItemsWhenSearchQueryIsNotEmpty() async throws {
		let sut = BreedsListViewModel(
			breedsNetworkService: .mock(),
			databaseService: .mock()
		)
		await sut.onViewAppeared()
		XCTAssertEqual(sut.filteredBreeds, .expectedBreeds)

		sut.searchQuery = "American"
		XCTAssertEqual(sut.filteredBreeds, .expectedAmericanBreeds)

		sut.searchQuery = "XPTOTTT"
		XCTAssertTrue(sut.filteredBreeds.isEmpty)
		
		sut.searchQuery = ""
		XCTAssertEqual(sut.filteredBreeds, .expectedBreeds)
	}


	func testAlertButtonsTapped_ShouldRetryFetch() async {
		let sut = BreedsListViewModel(
			breedsNetworkService: .mock(),
			destination: Destination.alert(
				.alertRetryFetchDynamic(
					addCancelButton: false
				)
			),
			databaseService: .mock()
		)
		XCTAssertTrue(sut.filteredBreeds.isEmpty)
		XCTAssertEqual(sut.destination, .alert(.alertRetryFetchDynamic(addCancelButton: false)))

		await sut.alertButtonsTapped(action: .confirmRetry)

		XCTAssertEqual(sut.filteredBreeds, .expectedBreeds)
		XCTAssertEqual(sut.destination, nil)
	}

	func testBottomReached_ShouldFetchMoreContent() async throws {
		var limitTest: Int = 0
		var pageTest: Int = 0

		let service = BreedsListNetworkService { limit, page in
			limitTest = limit
			pageTest = page
			return [Breed].breedsMock
		}

		let sut = BreedsListViewModel(
			breedsNetworkService: service,
			databaseService: .mock()
		)

		await sut.bottomReached()?.value

		XCTAssertEqual(sut.filteredBreeds, .expectedBreeds)
		XCTAssertEqual(pageTest, 1)
		XCTAssertEqual(limitTest, 8)
	}

	func testCardTapped_ShouldShowBreedDetailView() async throws {
		let sut = BreedsListViewModel(
			breedsNetworkService: .mock(),
			databaseService: .mock()
		)
		await sut.onViewAppeared()

		sut.cardTapped(breed: .breedMock)

		XCTAssertEqual(sut.destination, .detail(BreedDetailViewModel(breed: .breedMock)))
	}
}

extension IdentifiedArrayOf<BreedModel> {
	// swiftlint:disable line_length
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
			origin: "Greece",
			temperament: "Affectionate, Social, Intelligent, Playful, Active",
			breedDescription: "Native to the Greek islands known as the Cyclades in the Aegean Sea, these are natural cats, meaning they developed without humans getting involved in their breeding. As a breed, Aegean Cats are rare, although they are numerous on their home islands. They are generally friendly toward people and can be excellent cats for families with children.",
			lifeSpan: LifespanModel(
				upperValue: 12,
				lowerValue: 9
			),
			image: CatImageModel(
				id: "ozEvzdVM-",
				width: 1200,
				height: 800,
				url: "https://cdn2.thecatapi.com/images/ozEvzdVM-.jpg"
			)
		),
		BreedModel(
			id: "abob",
			name: "American Bobtail",
			origin: "United States",
			temperament: "Intelligent, Interactive, Lively, Playful, Sensitive",
			breedDescription: "American Bobtails are loving and incredibly intelligent cats possessing a distinctive wild appearance. They are extremely interactive cats that bond with their human family with great devotion.",
			lifeSpan: LifespanModel(
				upperValue: 15,
				lowerValue: 11
			),
			image: CatImageModel(
				id: "hBXicehMA",
				width: 1600,
				height: 951,
				url: "https://cdn2.thecatapi.com/images/hBXicehMA.jpg"
			)
		),
		BreedModel(
			id: "acur",
			name: "American Curl",
			origin: "United States",
			temperament: "Affectionate, Curious, Intelligent, Interactive, Lively, Playful, Social",
			breedDescription: "Distinguished by truly unique ears that curl back in a graceful arc, offering an alert, perky, happily surprised expression, they cause people to break out into a big smile when viewing their first Curl. Curls are very people-oriented, faithful, affectionate soulmates, adjusting remarkably fast to other pets, children, and new situations.",
			lifeSpan: LifespanModel(
				upperValue: 16,
				lowerValue: 12
			),
			image: CatImageModel(
				id: "xnsqonbjW",
				width: 1000,
				height: 964,
				url: "https://cdn2.thecatapi.com/images/xnsqonbjW.jpg"
			)
		),
		BreedModel(
			id: "asho",
			name: "American Shorthair",
			origin: "United States",
			temperament: "Active, Curious, Easy Going, Playful, Calm",
			breedDescription: "The American Shorthair is known for its longevity, robust health, good looks, sweet personality, and amiability with children, dogs, and other pets.",
			lifeSpan: LifespanModel(
				upperValue: 17,
				lowerValue: 15
			),
			image: CatImageModel(
				id: "JFPROfGtQ",
				width: 1600,
				height: 1200,
				url: "https://cdn2.thecatapi.com/images/JFPROfGtQ.jpg"
			)
		),
		BreedModel(
			id: "awir",
			name: "American Wirehair",
			origin: "United States",
			temperament: "Affectionate, Curious, Gentle, Intelligent, Interactive, Lively, Loyal, Playful, Sensible, Social",
			breedDescription: "The American Wirehair tends to be a calm and tolerant cat who takes life as it comes. His favorite hobby is bird-watching from a sunny windowsill, and his hunting ability will stand you in good stead if insects enter the house.",
			lifeSpan: LifespanModel(
				upperValue: 18,
				lowerValue: 14
			),
			image: CatImageModel(
				id: "8D--jCd21",
				width: 1280,
				height: 936,
				url: "https://cdn2.thecatapi.com/images/8D--jCd21.jpg"
			)
		),
		BreedModel(
			id: "amau",
			name: "Arabian Mau",
			origin: "United Arab Emirates",
			temperament: "Affectionate, Agile, Curious, Independent, Playful, Loyal",
			breedDescription: "Arabian Mau cats are social and energetic. Due to their energy levels, these cats do best in homes where their owners will be able to provide them with plenty of playtime, attention and interaction from their owners. These kitties are friendly, intelligent, and adaptable, and will even get along well with other pets and children.",
			lifeSpan: LifespanModel(upperValue: 14, lowerValue: 12),
			image: CatImageModel(
				id: "k71ULYfRr",
				width: 2048,
				height: 1554,
				url: "https://cdn2.thecatapi.com/images/k71ULYfRr.jpg"
			)
		),
		BreedModel(
			id: "amis",
			name: "Australian Mist",
			origin: "Australia",
			temperament: "Lively, Social, Fun-loving, Relaxed, Affectionate",
			breedDescription: "The Australian Mist thrives on human companionship. Tolerant of even the youngest of children, these friendly felines enjoy playing games and being part of the hustle and bustle of a busy household. They make entertaining companions for people of all ages, and are happy to remain indoors between dusk and dawn or to be wholly indoor pets.",
			lifeSpan: LifespanModel(upperValue: 16, lowerValue: 12),
			image: CatImageModel(
				id: "_6x-3TiCA",
				width: 1231,
				height: 1165,
				url: "https://cdn2.thecatapi.com/images/_6x-3TiCA.jpg"
			)
		),
	]
	static let expectedAmericanBreeds: Self = [
		BreedModel(
			id: "abob",
			name: "American Bobtail",
			origin: "United States",
			temperament: "Intelligent, Interactive, Lively, Playful, Sensitive",
			breedDescription: "American Bobtails are loving and incredibly intelligent cats possessing a distinctive wild appearance. They are extremely interactive cats that bond with their human family with great devotion.",
			lifeSpan: LifespanModel(
				upperValue: 15,
				lowerValue: 11
			),
			image: CatImageModel(
				id: "hBXicehMA",
				width: 1600,
				height: 951,
				url: "https://cdn2.thecatapi.com/images/hBXicehMA.jpg"
			)
		),
		BreedModel(
			id: "acur",
			name: "American Curl",
			origin: "United States",
			temperament: "Affectionate, Curious, Intelligent, Interactive, Lively, Playful, Social",
			breedDescription: "Distinguished by truly unique ears that curl back in a graceful arc, offering an alert, perky, happily surprised expression, they cause people to break out into a big smile when viewing their first Curl. Curls are very people-oriented, faithful, affectionate soulmates, adjusting remarkably fast to other pets, children, and new situations.",
			lifeSpan: LifespanModel(
				upperValue: 16,
				lowerValue: 12
			),
			image: CatImageModel(
				id: "xnsqonbjW",
				width: 1000,
				height: 964,
				url: "https://cdn2.thecatapi.com/images/xnsqonbjW.jpg"
			)
		),
		BreedModel(
			id: "asho",
			name: "American Shorthair",
			origin: "United States",
			temperament: "Active, Curious, Easy Going, Playful, Calm",
			breedDescription: "The American Shorthair is known for its longevity, robust health, good looks, sweet personality, and amiability with children, dogs, and other pets.",
			lifeSpan: LifespanModel(
				upperValue: 17,
				lowerValue: 15
			),
			image: CatImageModel(
				id: "JFPROfGtQ",
				width: 1600,
				height: 1200,
				url: "https://cdn2.thecatapi.com/images/JFPROfGtQ.jpg"
			)
		),
		BreedModel(
			id: "awir",
			name: "American Wirehair",
			origin: "United States",
			temperament: "Affectionate, Curious, Gentle, Intelligent, Interactive, Lively, Loyal, Playful, Sensible, Social",
			breedDescription: "The American Wirehair tends to be a calm and tolerant cat who takes life as it comes. His favorite hobby is bird-watching from a sunny windowsill, and his hunting ability will stand you in good stead if insects enter the house.",
			lifeSpan: LifespanModel(
				upperValue: 18,
				lowerValue: 14
			),
			image: CatImageModel(
				id: "8D--jCd21",
				width: 1280,
				height: 936,
				url: "https://cdn2.thecatapi.com/images/8D--jCd21.jpg"
			)
		)
	]
	// swiftlint:enable line_length
}
