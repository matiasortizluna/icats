import SwiftUI
import SwiftUINavigation

struct BreedsListView: View {
	let columns = [
		GridItem(.flexible()),
		GridItem(.flexible())
	]
	@State var model: BreedsListViewModel

	var body: some View {
		NavigationStack {
			ScrollView {
				LazyVGrid(columns: columns, spacing: .gridSpacing) {
					ForEach(Array(model.filteredBreeds.enumerated()), id: \.offset) { index, breed in
						Button {
							model.cardTapped(breed: breed)
						} label: {
							CatCard(breedModel: breed)
						}
						.onAppear {
							if index + Int.bottomThreshold > model.filteredBreeds.count {
								model.bottomReached()
							}
						}
					}
					.navigationDestination(item: $model.destination.detail) { breedDetailModel in
						BreedsDetailView(model: breedDetailModel)
					}
				}
				.padding()
			}
			.navigationTitle(String.breeds)
			.navigationBarTitleDisplayMode(.large)
			.searchable(text: $model.searchQuery)
			.task {
				await model.onViewAppeared()
			}
			.alert(item: $model.destination.alert) { alert in
				return Alert(alert) { action in
					guard let unwrappedAction = action else { return }
					model.alertButtonsTapped(action: unwrappedAction)
				}
			}
		}
	}
}

private extension CGFloat {
	static let gridSpacing: Self = 20
}

private extension Int {
	static let bottomThreshold: Self = 2
}

struct BreedsView_Previews: PreviewProvider {
	static var previews: some View {
		BreedsListView(
			model: BreedsListViewModel(
				breedsNetworkService: BreedsListNetworkService.mockPreview()
			)
		)
	}
}
