import SwiftUI
import SwiftData

struct BreedsFavoritesView: View {

    var favoriteBreeds: [BreedModel] = []

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            if favoriteBreeds.isEmpty {
                Text("You have not selected any favorite breeds yet.")
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(favoriteBreeds, id: \.id) { breed in
							//NavigationLink(destination: BreedsDetailView(model: breed)) {
                                CatCard(breed: breed)
                            //}
                        }
                    }
                    .padding()
                }
                .navigationTitle("Favorite Breeds")
                .navigationBarTitleDisplayMode(.large)
            }
        }
    }
}

#Preview {
    BreedsFavoritesView()
}
