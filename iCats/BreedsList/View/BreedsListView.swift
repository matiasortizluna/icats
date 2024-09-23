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
				HStack() {
					Spacer()
					Button {
						self.model.infoTapped()
					} label: {
						Image(systemName: "info")
							.padding(.horizontal, 30)
					}
				}
				LazyVGrid(columns: columns, spacing: 20) {
					ForEach(Array(self.model.filteredBreeds.enumerated()), id: \.offset) { index, breed in
						Button {
							self.model.cardTapped(breed: breed)
						} label: {
							CatCard(breed: breed)
						}
						.task{
							if index+1 < self.model.breeds.count {
								await self.model.bottomReached()
							}
						}
					}
					.navigationDestination(item: self.$model.destination.detail) { breedDetailModel in
						BreedsDetailView(model: breedDetailModel)
					}
				}
				.padding()
			}
			.navigationTitle("Breeds")
			.navigationBarTitleDisplayMode(.large)
			.searchable(text: self.$model.searchQuery)
			.onAppear(perform: {
				Task{
					try await self.model.viewAppeared()
				}
			})
		}
	}
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
