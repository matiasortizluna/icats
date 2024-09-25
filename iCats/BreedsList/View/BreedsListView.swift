import SwiftUI
import SwiftUINavigation

struct BreedsListView: View {

	let columns = [
		GridItem(.flexible()),
		GridItem(.flexible())
	]

	@State var model : BreedsListViewModel

	var body: some View {
		NavigationStack {
			ScrollView {
				LazyVGrid(columns: columns, spacing: .gridSpacing) {
					ForEach(Array(model.filteredBreeds.enumerated()), id: \.offset) { index, breed in
						Button {
							model.cardTapped(breed: breed)
						} label: {
							CatCard(breed: breed)
						}
						.task{
							if index+1 < model.filteredBreeds.count {
								await model.bottomReached()
							}
						}
					}
					.navigationDestination(item: $model.destination.detail) { breedDetailModel in
						BreedsDetailView(model: breedDetailModel)
					}
				}
				.padding()
//				.alert(item: $model.destination.alert) { action in
//					model.alertButtonTapped(action)
//				}
			}
			.navigationTitle("Breeds")
			.navigationBarTitleDisplayMode(.large)
			.searchable(text: $model.searchQuery)
			.onAppear(perform: {
				Task{
					try await model.viewAppeared()
				}
			})
		}
	}
}

private extension CGFloat {
	static let gridSpacing: Self = 20
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
