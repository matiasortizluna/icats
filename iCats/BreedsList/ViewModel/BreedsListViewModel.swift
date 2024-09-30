import Foundation
import SwiftUINavigation
import IdentifiedCollections

@Observable
class BreedsListViewModel {
	var destination: Destination? {
		didSet { bind() }
	}

	let breedsNetworkService: BreedsListNetworkService

	var page: Int = 0

	var searchQuery: String = ""

	private var breeds: IdentifiedArrayOf<BreedModel> = []
	var filteredBreeds: IdentifiedArrayOf<BreedModel> {
		if searchQuery.isEmpty {
			return breeds
		} else {
			return breeds.filter { $0.name.lowercased().starts(with: searchQuery.lowercased()) }
		}
	}

	init(breedsNetworkService: BreedsListNetworkService, destination: Destination? = nil) {
		self.breedsNetworkService = breedsNetworkService
		self.destination = destination
	}

	func bind() {
	}

	func onViewAppeared() async {
		await fetchMoreContent()
	}

	func alertButtonsTapped(action: AlertAction) async {
		switch action {
		case .confirmRetry:
			await alertConfirmRetryButtonTapped()
		case .cancel:
			alertCancelButtonTapped()
		}
	}

	@discardableResult
	func bottomReached() -> Task<(), Never>? {
		guard searchQuery.isEmpty else { return nil }
		return Task {
			page+=1
			await fetchMoreContent()
		}
	}

	func cardTapped(breed: BreedModel) {
		destination = .detail(BreedDetailViewModel(breed: breed))
	}

	private func alertConfirmRetryButtonTapped() async {
		await fetchMoreContent()
		if (!breeds.isEmpty) {
			destination = nil
		}
	}

	private func alertCancelButtonTapped() {
		destination = nil
	}

	@MainActor
	private func updateView(with newBreeds: [BreedModel]) {
		self.breeds.append(contentsOf: newBreeds)
	}

	private func fetchBreeds() async throws -> [BreedModel] {
		let breedsAPI = try await breedsNetworkService.fetchBreeds(.limitItemsPerPage, page)
		return breedsAPI.map { BreedModel(breedAPI: $0) }
	}

	private func fetchMoreContent() async {
		do {
			try await updateView(with: fetchBreeds())
		} catch {
			print("Unexpected error: \(error).")
			if (.limitItemsPerPage > breeds.count) {
				self.destination = .alert(.alertRetryFetchDynamic(addCancelButton: false))
			} else {
				self.destination = .alert(.alertRetryFetchDynamic(addCancelButton: true))
			}
		}
	}
}

public extension ButtonState where Action == AlertAction {
	static let confirmRetryButton: Self = ButtonState(
		role: .cancel,
		action: AlertAction.confirmRetry,
		label: { TextState("Confirm Retry") }
	)
	static let dismissButton: Self = ButtonState(
		role: .none,
		action: AlertAction.cancel,
		label: { TextState("Dismiss") }
	)
}

@CasePathable
public enum Destination: Equatable {
	case detail(BreedDetailViewModel)
	case information
	case alert(AlertState<AlertAction>)
}

public enum AlertAction {
	case confirmRetry
	case cancel
}

public extension AlertState where Action == AlertAction {
	static func alertRetryFetchDynamic(addCancelButton: Bool) -> Self {
		var actionButtons : [ButtonState<AlertAction>] = []
		if (addCancelButton == true) {
			actionButtons.append(.dismissButton)
		}
		actionButtons.append(.confirmRetryButton)

		return AlertState(
			title: { TextState("Do you want to retry to fetch breeds data?") },
			actions: {
				return actionButtons
			},
			message: { TextState("There was an error when fetching breeds data from the CatsAPI. You can try to fetch the data again by selecting the option.") }
		)
	}
}

private extension Int {
	static let limitItemsPerPage: Self = 8
}
