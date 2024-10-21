import Foundation
import SwiftUINavigation
import IdentifiedCollections

@Observable
class BreedsListViewModel {
	var viewState: ViewState

	var destination: Destination?

	var searchQuery: String = ""

	private var breeds: IdentifiedArrayOf<BreedModel> = []
	var filteredBreeds: IdentifiedArrayOf<BreedModel> {
		if searchQuery.isEmpty {
			return breeds
		} else {
			return breeds.filter { $0.name.lowercased().starts(with: searchQuery.lowercased()) }
		}
	}

	private let breedsNetworkService: BreedsListNetworkService
	private let databaseService: DatabaseService

	private var page: Int {
		return breeds.count / .limitItemsPerPage
	}
	private var endContent: Bool = false

	init(
		breedsNetworkService: BreedsListNetworkService,
		destination: Destination? = nil,
		viewState: ViewState = .ready,
		databaseService: DatabaseService
	) {
		self.breedsNetworkService = breedsNetworkService
		self.destination = destination
		self.viewState = viewState
		self.databaseService = databaseService
	}

	func onViewAppeared() async {
		let breedsFromDatabase = (try? await databaseService.readBreeds()) ?? []
		if breedsFromDatabase.isEmpty {
			if !breeds.isEmpty {
				breeds = []
				endContent = false
			}
			await fetchMoreContent()
		}
		await updateView(with: breedsFromDatabase)
	}

	@discardableResult
	func bottomReached() -> Task<(), Never>? {
		guard searchQuery.isEmpty, viewState == .ready else { return nil }
		return Task {
			await fetchMoreContent()
		}
	}

	func alertButtonsTapped(action: AlertAction) async {
		switch action {
		case .confirmRetry:
			await alertConfirmRetryButtonTapped()
		case .cancel:
			alertCancelButtonTapped()
		}
	}

	func cardTapped(breed: BreedModel) {
		destination = .detail(BreedDetailViewModel(breed: breed))
	}

	private func fetchMoreContent() async {
		do {
			if !endContent {
				let breeds = try await fetchBreedsPerPage()
				if breeds.count < .limitItemsPerPage {
					endContent = true
				}
				try await saveBreedsOnDisk(breeds)
				await updateView(with: breeds)
			}
		} catch {
			if breeds.isEmpty {
				self.destination = .alert(.alertRetryFetchDynamic(addCancelButton: true))
			} else {
				self.destination = .alert(.alertRetryFetchDynamic(addCancelButton: false))
			}
		}
	}

	private func fetchBreedsPerPage() async throws -> [BreedModel] {
		breeds.isEmpty ? await changeViewState(.fullScreenLoading) : await changeViewState(.spinnerLoading)

		let breedsFromNetwork = try await breedsNetworkService.fetch(.limitItemsPerPage, page)

		guard !breedsFromNetwork.isEmpty else {
			await changeViewState(.ready)
			return []
		}
		let breeds : [BreedModel] = breedsFromNetwork.map { BreedModel(breedAPI: $0) }

		await changeViewState(.ready)
		return breeds
	}

	private func saveBreedsOnDisk(_ breeds: [BreedModel]) async throws {
		guard !breeds.isEmpty else { return }

		for breed in breeds {
			try await databaseService.insertBreed(breed)
		}

		try await databaseService.save()
	}

	@MainActor
	private func changeViewState(_ newState: ViewState) {
		viewState = newState
	}

	private func alertConfirmRetryButtonTapped() async {
		destination = nil
		await fetchMoreContent()
	}

	private func alertCancelButtonTapped() {
		destination = nil
	}

	@MainActor
	private func updateView(with newBreeds: [BreedModel]) {
		self.breeds.append(contentsOf: newBreeds)
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
		if addCancelButton == true {
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
