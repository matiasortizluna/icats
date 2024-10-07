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

	var viewState: ViewState

	private var breeds: IdentifiedArrayOf<BreedModel> = []
	var filteredBreeds: IdentifiedArrayOf<BreedModel> {
		if searchQuery.isEmpty {
			return breeds
		} else {
			return breeds.filter { $0.name.lowercased().starts(with: searchQuery.lowercased()) }
		}
	}

	let databaseService: DatabaseService

	init(
		breedsNetworkService: BreedsListNetworkService,
		destination: Destination? = nil,
		viewState: ViewState = .ready,
		databaseService: DatabaseService? = nil
	) {
		self.breedsNetworkService = breedsNetworkService
		self.destination = destination
		self.viewState = viewState
		self.databaseService = databaseService ?? DatabaseService()
	}

	func bind() {
	}

	func onViewAppeared() async {
//		databaseService.cleanBD()
		await changeViewState(.fullScreenLoading)
		do {
			try await fetchMoreContent()
		} catch BreedListError.emptyBreeds {
			print(BreedListError.emptyBreeds.localizedDescription)
		} catch {
			print(error.localizedDescription)
		}
		await changeViewState(.ready)
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
		print("page \(page)")
		guard searchQuery.isEmpty, viewState == .ready else { return nil }
		viewState = .spinnerLoading
		return Task {
			page+=1
			do {
				try await fetchMoreContent()
				await changeViewState(.ready)
			} catch BreedListError.emptyBreeds {
				print(BreedListError.emptyBreeds.localizedDescription)
			} catch {
				print(error.localizedDescription)
			}
		}
	}

	func cardTapped(breed: BreedModel) {
		destination = .detail(BreedDetailViewModel(breed: breed))
	}

	@MainActor
	private func changeViewState(_ newState: ViewState) {
		viewState = newState
	}

	private func alertConfirmRetryButtonTapped() async {
		do {
			destination = nil
			if filteredBreeds.isEmpty {
				await changeViewState(.fullScreenLoading)
			} else {
				await changeViewState(.spinnerLoading)
			}
			try await fetchMoreContent()
			await changeViewState(.ready)
		} catch BreedListError.emptyBreeds {
			print(BreedListError.emptyBreeds.localizedDescription)
		} catch {
			print(error.localizedDescription)
		}
	}

	private func alertCancelButtonTapped() {
		destination = nil
	}

	private func fetchMoreContent() async throws {
		do {
			let breeds = try await fetchBreeds()
			guard !breeds.isEmpty else { throw BreedListError.emptyBreeds }
			await updateView(with: breeds)

		} catch let error as BreedListError {
			throw error

		} catch {
			if .limitItemsPerPage > breeds.count {
				self.destination = .alert(.alertRetryFetchDynamic(addCancelButton: false))
			} else {
				self.destination = .alert(.alertRetryFetchDynamic(addCancelButton: true))
			}
		}
	}

	private func fetchBreeds() async throws -> [BreedModel] {
		let breeds = databaseService.fetchBreeds()
		if (breeds.isEmpty) {
			let breedsAPI = try await breedsNetworkService.fetchBreeds(.limitItemsPerPage, page)
			let breeds = breedsAPI.map { BreedModel(breedAPI: $0) }
			databaseService.saveOnDisk(breeds: breeds)
			return breeds
		}
		return breeds
	}

	@MainActor
	private func updateView(with newBreeds: [BreedModel]) {
		self.breeds.append(contentsOf: newBreeds)
	}

	enum BreedListError: Error {
		case emptyBreeds
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
