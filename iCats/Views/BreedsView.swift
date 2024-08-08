import SwiftUI

struct BreedsView: View {
    
    @EnvironmentObject private var viewModel: CatViewModel
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            if viewModel.breeds.isEmpty {
                Text("Loading...")
                    .onAppear {
                        // Perform the fetch operation
                        viewModel.fetchBreeds()
                    }
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.breeds, id: \.id) { breed in
                            NavigationLink(destination: BreedsDetailView(breed: breed)) {
                                CatsCard(breed: breed)
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle("Breeds")
                .navigationBarTitleDisplayMode(.large)
            }
        }
    }
}

#Preview {
    BreedsView()
        .environmentObject(CatViewModel())
}
