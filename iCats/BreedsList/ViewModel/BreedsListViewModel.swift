import Foundation
import SwiftUINavigation
import IdentifiedCollections

@Observable
class BreedsListViewModel {
	var destination: Destination?

	let breedsNetworkService: BreedsListNetworkService
	let databaseService: DatabaseService

	var page: Int {
		return breeds.count / .limitItemsPerPage
	}
	var endContent: Bool = false

	var searchQuery: String = ""

	var viewState: ViewState

	private var breeds: IdentifiedArrayOf<BreedModel> = []
	var filteredBreeds: IdentifiedArrayOf<BreedModel> {
		if searchQuery.isEmpty {
			return breeds
		} else {
			return breeds.filter { $0.name.lowercased().starts(with: searchQuery.lowercased()) }
		}
	}

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
		let databaseBreedsCount = await getBreedsCount()
		if (databaseBreedsCount < breeds.count) {
			breeds = []
		}
		await fetchMoreContent()
	}

	private func getBreedsCount() async -> Int {
		do {
			return try await databaseService.count(DatabaseEntity.breed)
		} catch {
			print(error.localizedDescription)
		}
		return -1
	}

	@discardableResult
	func bottomReached() -> Task<(), Never>? {
		//		guard searchQuery.isEmpty, viewState == .ready else { return nil }
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
			if (!endContent) {
				let breeds = try await fetchBreeds()
				guard !breeds.isEmpty else {
					// Handle of Product related errors
					// vmaos fazer update da variavel de controle
					return
				}
				await updateView(with: breeds)
			}

		} catch {
			// Handle of Service related errors
			if .limitItemsPerPage > breeds.count {
				self.destination = .alert(.alertRetryFetchDynamic(addCancelButton: false))
			} else {
				self.destination = .alert(.alertRetryFetchDynamic(addCancelButton: true))
			}
		}
	}

	private func fetchBreeds() async throws -> [BreedModel] {
		let breedsFromDatabase = try await databaseService.readBreeds()

		print("breedsFromDatabase.isEmpty \(breedsFromDatabase.isEmpty)")
		print("endContent \(endContent)")
		guard breedsFromDatabase.isEmpty || endContent else {
			return breedsFromDatabase
		}

		breeds.isEmpty ? await changeViewState(.fullScreenLoading) : await changeViewState(.spinnerLoading)

		let breedsFromNetwork = try await breedsNetworkService.fetch(.limitItemsPerPage, page)
		if (breedsFromNetwork.isEmpty && page>0) {
			endContent = true
		}
		let breeds: [BreedModel] = breedsFromNetwork.map { BreedModel(breedAPI: $0) }
		try await saveBreedsOnDisk(breeds)

		await changeViewState(.ready)
		return breeds
	}

	private func saveBreedsOnDisk(_ breeds: [BreedModel]) async throws {
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
