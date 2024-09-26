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
		case alert(AlertState<AlertAction>)
	}

	enum AlertAction {
		case confirmRetry
		case cancel
	}

	let breedsNetworkService: BreedsListNetworkService

	var page: Int = 0

	var searchQuery: String = ""

	private var breeds: [BreedModel] = []
	var filteredBreeds: [BreedModel] {
		if searchQuery.isEmpty {
			return breeds
		} else {
			return breeds.filter { $0.name.lowercased().starts(with: searchQuery.lowercased()) }
		}
	}

	init(breedsNetworkService: BreedsListNetworkService) {
		self.breedsNetworkService = breedsNetworkService
	}

	func bind() {
	}

	func onViewAppeared() async {
		print("onViewAppeared")
		await fetchMoreContent()
	}

	func fetchBreeds() async throws -> [BreedModel] {
		let breedsAPI = try await breedsNetworkService.fetchBreeds(.limitItemsPerPage, page)
		return breedsAPI.map { BreedModel(breedAPI: $0) }
	}

	func fetchMoreContent() async {
		print("fetchMoreContent")
		do {
			try await updateView(with: fetchBreeds())
			print("try await updateView(with: fetchBreeds())")
		} catch {
			self.destination = .alert(.alertRetryFetch)
			print("self.destination = .alert(.alertRetryFetch)")
		}
	}

	func alertButtonsTapped(action: AlertAction) {
		switch action {
		case .confirmRetry:
			alertConfirmRetryButtonTapped()
		case .cancel:
			alertCancelButtonTapped()
		}
	}

	func alertConfirmRetryButtonTapped() {
		print("alertConfirmRetryButtonTapped")
		//		await fetchMoreContent()
	}

	func alertCancelButtonTapped() {
		print("alertCancelButtonTapped")
	}

	func bottomReached() {
		guard searchQuery.isEmpty else { return }
		Task {
			page+=1
			await fetchMoreContent()
		}
	}

	func cardTapped(breed: BreedModel) {
		destination = .detail(BreedDetailViewModel(breed: breed))
	}

	@MainActor
	func updateView(with newBreeds: [BreedModel]) {
		print("updatedView")
		self.breeds.append(contentsOf: newBreeds)
	}
}

private extension ButtonState where Action == BreedsListViewModel.AlertAction {
	static let confirmRetryButton: Self = ButtonState(
		role: .cancel,
		action: BreedsListViewModel.AlertAction.confirmRetry,
		label: { TextState("Confirm Retry") }
	)
	static let dismissButton: Self = ButtonState(
		role: .none,
		action: BreedsListViewModel.AlertAction.cancel,
		label: { TextState("Dismiss") }
	)
}

private extension AlertState where Action == BreedsListViewModel.AlertAction {
	static func alertRetryFetchDynamic(addCancelButton: Bool) -> Self {
		var actionButtons : [ButtonState<BreedsListViewModel.AlertAction>] = []
		if (addCancelButton == true) {
			actionButtons.append(contentsOf: [.dismissButton, .confirmRetryButton])
		} else {
			actionButtons.append(.confirmRetryButton)
		}

		return AlertState(
			title: { TextState("Do you want to retry to fetch breeds data?") },
			actions: {
				return actionButtons
			},
			message: { TextState("There was an error when fetching breeds data from the CatsAPI. You can try to fetch the data again by selecting the option.") }
		)
	}

	static let alertRetryFetch: Self = AlertState(
		title: { TextState("Do you want to retry to fetch breeds data?") },
		actions: {
			return [
				ButtonState(
					role: .none,
					action: .cancel,
					label: { TextState("Nevermind") }
				),
				ButtonState(
					role: .cancel,
					action: .confirmRetry,
					label: { TextState("Confirm Retry") }
				),
			]
		},
		message: { TextState("There was an error when fetching breeds data from the CatsAPI. You can try to fetch the data again by selecting the option.") }
	)
}

private extension Int {
	static let limitItemsPerPage: Self = 8
}
