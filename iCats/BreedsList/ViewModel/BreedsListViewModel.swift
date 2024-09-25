import Foundation
import SwiftUINavigation

@Observable
class BreedsListViewModel {
	var destination: Destination? {
		didSet { bind() }
	}

	@CasePathable
	enum Destination {
		case detail(BreedDetailViewModel)
		case information
//		case alert(AlertAction)
	}
//	enum AlertAction : Identifiable {
//		case confirmRetry
//	}

	let breedsNetworkService : BreedsListNetworkService

	var page : Int = 0

	var searchQuery: String = ""

	private var breeds : [BreedModel] = []
	var filteredBreeds: [BreedModel] {
		if searchQuery.isEmpty {
			return breeds
		} else {
			return breeds.filter { $0.name.lowercased().contains(searchQuery.lowercased()) }
		}
	}

	init(breedsNetworkService : BreedsListNetworkService) {
		self.breedsNetworkService = breedsNetworkService
	}

	func bind() {
	}

	func viewAppeared() async throws {
		await fetchMoreContent()
	}

	func fetchBreeds() async throws -> [BreedModel] {
		let breedsAPI = try await breedsNetworkService.fetchBreeds(.limitItemsPerPage, page)
		return breedsAPI.map { BreedModel(breedAPI: $0) }
	}

	func fetchMoreContent() async {
		do {
			try await updateView(breeds: fetchBreeds())

		} catch {
			// TODO: Implement Alert
//			self.destination = .alert(.confirmRetry)
			print("Error on Fetching More Content")
		}
	}

//	func alertButtonTapped(_ action: AlertAction) async {
//		switch action {
//		case .confirmRetry:
//			await fetchMoreContent()
//		}
//	}

	func bottomReached() async {
		page+=1
		await fetchMoreContent()
	}

	func cardTapped(breed : BreedModel) {
		destination = .detail(BreedDetailViewModel(breed: breed))
	}

	func infoTapped() {

	}

	@MainActor
	func updateView(breeds : [BreedModel]) {
		_ = breeds.map { self.breeds.append($0) }
	}

}

// extension AlertState where Action == BreedsListViewModel.AlertAction {
//	static let retry = AlertState {
//		TextState("Retry Fetching More Content?")
//	} actions: {
//		.init(role: .cancel,
//			  label: {
//			TextState(
//				"Nevermind"
//			)
//		})
//	} message: {
//		TextState(
//			"Are you sure you want retry to fetch more content?"
//		)
//	}
// }

private extension Int {
	static let limitItemsPerPage: Self = 8
}
