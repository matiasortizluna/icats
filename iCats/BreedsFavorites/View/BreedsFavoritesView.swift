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
					LazyVGrid(columns: columns, spacing: .gridSpacing) {
                        ForEach(favoriteBreeds, id: \.id) { breed in
//							NavigationLink(destination: BreedsDetailView(model: breed)) {
                                CatCard(breed: breed)
//                            }
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

private extension CGFloat {
	static let gridSpacing: Self = 20
}

#Preview {
    BreedsFavoritesView()
}
