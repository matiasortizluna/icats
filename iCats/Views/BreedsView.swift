import SwiftUI
import SwiftyJSON
import SwiftData

struct BreedsView: View {
    
    @EnvironmentObject var viewModel: BreedsViewModel
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            if viewModel.breeds.isEmpty {
                Text("Loading...")
                    .onAppear {
                        self.viewModel.fetchBreeds()
                    }
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.filteredBreeds, id: \.id) { breed in
                            NavigationLink(destination: BreedsDetailView(breed: breed)) {
                                CatsCard(breed: breed)
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle("Breeds")
                .navigationBarTitleDisplayMode(.large)
                .searchable(text: $viewModel.searchQuery)
            }
        }
    }
}

struct BreedsView_Previews: PreviewProvider {
    static var previews: some View {
        let previewModelContainer = try! ModelContainer(for: Breed.self, Weight.self, CatImage.self)
        BreedsView()
            .modelContainer(previewModelContainer)
    }
}
