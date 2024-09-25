import SwiftUI
import SwiftData

struct ContentView: View {
	// TODO: Please remove this space between the name and the colon
	let model : BreedsListViewModel

    var body: some View {
        TabView(selection: .constant(2)) {
			// TODO: Could you add private extension to the Ints and a add the string literals to the public String extension?
            BreedsFavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
                .tag(1)

			BreedsListView(model: model)
                .tabItem {
                    Label("Breeds", systemImage: "cat")
                }
                .tag(2)

            AboutView()
                .tabItem {
                    Label("About", systemImage: "person")
                }
                .tag(3)
        }
        .accentColor(Color(.purple))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView(model: BreedsListViewModel(breedsNetworkService: BreedsListNetworkService.mockPreview()))
    }
}
