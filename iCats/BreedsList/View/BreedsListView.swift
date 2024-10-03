import SwiftUI
import SwiftUINavigation

struct BreedsListView: View {
	let columns = [
		GridItem(.flexible()),
		GridItem(.flexible())
	]
	@State var model: BreedsListViewModel

	var body: some View {
		ZStack {
			switch model.viewState {
			case .ready, .spinnerLoading:
				mainContent
			case .fullScreenLoading:
				ProgressView()
			}
		}
		.task {
			await model.onViewAppeared()
		}
	}

	private var mainContent: some View {
		NavigationStack {
			ScrollView {
				VStack(spacing: .stackSpacing) {
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
					if (model.viewState == .spinnerLoading) {
						ProgressView()
							.padding(.bottom, .paddingSpacing)
					}
				}
			}
			.navigationTitle(String.breeds)
			.navigationBarTitleDisplayMode(.large)
			.searchable(text: $model.searchQuery)
			.alert(item: $model.destination.alert) { alert in
				return Alert(alert) { action in
					guard let unwrappedAction = action else { return }
					await model.alertButtonsTapped(action: unwrappedAction)
				}
			}
		}
	}
}

private extension CGFloat {
	static let gridSpacing: Self = 20
	static let stackSpacing: Self = 8
	static let paddingSpacing: Self = 16
}

private extension Int {
	static let bottomThreshold: Self = 3
}

struct BreedsView_Previews: PreviewProvider {
	static var previews: some View {
		BreedsListView(
			model: BreedsListViewModel(
				breedsNetworkService: BreedsListNetworkService.mock()
			)
		)
	}
}
