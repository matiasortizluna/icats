import Foundation
import SwiftUINavigation

@MainActor
@Observable
class BreedsListViewModel {
	var destination: Destination? {
		didSet { self.bind() }
	}

	@CasePathable
	enum Destination {
		case detail(BreedDetailViewModel)
		case information
	}

	private(set) var breeds : [BreedModel] = []

	let breedsNetworkService : BreedsListNetworkService

	let limitItemsPerPage = 8
	var page : Int = 0

	var searchQuery: String = ""
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
		let breedsAPI = try await breedsNetworkService.fetchBreeds(limitItemsPerPage, page)
		
		var breedsModel : [BreedModel] = []

		for breedAPI in breedsAPI {
			breedsModel.append(
				BreedModel(breedAPI: breedAPI)
			)
		}

		self.updateView(breeds: breedsModel)
	}

	func bottomReached() async {
		
		self.page+=1

		do {
			let breedsAPI = try await breedsNetworkService.fetchBreeds(limitItemsPerPage, page)

			var breedsModel : [BreedModel] = []

			for breedAPI in breedsAPI {
				breedsModel.append(
					BreedModel(breedAPI: breedAPI)
				)
			}

			self.updateView(breeds: breedsModel)

		} catch {
			print("Erro on fetchBreeds")
		}
	}

	func cardTapped(breed : BreedModel) {
		self.destination = .detail(BreedDetailViewModel(breed: breed))
	}

	func infoTapped() {

	}

	func updateView(breeds : [BreedModel]) {
		for breed in breeds {
			self.breeds.append(breed)
		}
	}

}
