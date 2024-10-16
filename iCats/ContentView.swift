import SwiftUI

struct ContentView: View {
	let breedsListViewModel: BreedsListViewModel
	let aboutViewModel: AboutViewModel

    var body: some View {

		TabView(selection: .constant(Int.tabSelection)) {
            BreedsFavoritesView()
                .tabItem {
					Label(String.favorites, systemImage: String.tabFavoritesSymbol)
                }
				.tag(Int.tabFavorites)

			BreedsListView(model: breedsListViewModel)
                .tabItem {
					Label(String.breeds, systemImage: String.tabBreedsSymbol)
                }
				.tag(Int.tabBreeds)

			AboutView(model: aboutViewModel)
                .tabItem {
					Label(String.about, systemImage: String.tabAboutSymbol)
                }
				.tag(Int.tabAbout)
        }
        .accentColor(Color(.purple))
    }
}

private extension Int {
	static let tabFavorites: Self = 1
	static let tabBreeds: Self = 2
	static let tabAbout: Self = 3
	static let tabSelection: Self = 2
}

private extension String {
	static let tabFavoritesSymbol: Self = "heart"
	static let tabBreedsSymbol: Self = "cat"
	static let tabAboutSymbol: Self = "person"
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView(
			breedsListViewModel: BreedsListViewModel(
				breedsNetworkService: BreedsListNetworkService.mock(),
				databaseService: DatabaseService.mock()
			),
			aboutViewModel: AboutViewModel(
				databaseService: DatabaseService.mock()
			)
		)
    }
}
