import SwiftUI
import SwiftData

struct ContentView: View {
	let model : BreedsListViewModel

    var body: some View {
        TabView(selection: .constant(2)) {
            
            BreedsFavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
                .tag(1)

			BreedsListView(model: self.model)
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
        let previewModelContainer = try! ModelContainer(for: BreedEntity.self, CatImageEntity.self)
        
		ContentView(model: BreedsListViewModel(breedsNetworkService: BreedsListNetworkService.mockPreview()))
            .modelContainer(previewModelContainer)
    }
}
