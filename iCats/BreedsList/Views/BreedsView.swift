import SwiftUI
import SwiftyJSON
import SwiftData

struct BreedsView: View {

    @State var breeds: [BreedsData] = []

    @State private var searchQuery: String = ""
    @State private var errorMessage: String?

	let limitItemsPerPage = 8
	@State var page : Int = 0
	@State private var breedsNetworkService = BreedsNetworkService.live(networkService: NetworkService.live())

    var filteredBreeds: [BreedsData] {
        if searchQuery.isEmpty {
            return breeds
        } else {
            return breeds.filter { $0.name.lowercased().contains(searchQuery.lowercased()) }
        }
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            if let errorMessage = errorMessage {
                VStack {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
					TextButton(
						label: "Tap to Try Again",
						labelColor: .black,
						rectangleColor: .purple,
						action: {
//								Task {
//									do {
//										let result = try await breedsNetworkService.fetchBreeds(limitItemsPerPage, page)
//										for breed in result {
//											self.breeds.append(breed)
//										}
//									} catch {
//										print("Error on request")
//									}
//								}
						}
					)
                }
                .navigationTitle("Error")
            } else
            if breeds.isEmpty {
				TextButton(
					label: "Tap to Try Again",
					labelColor: .white,
					rectangleColor: .purple,
					action: {
//						Task {
//								do {
//									let result = try await breedsNetworkService.fetchBreeds(limitItemsPerPage, page)
//									for breed in result {
//										self.breeds.append(breed)
//									}
//								} catch {
//									print("Error on request")
//								}
//							}
					}
				)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
						ForEach(Array(filteredBreeds.enumerated()), id: \.offset) { index, breed in
                            NavigationLink(destination: BreedsDetailView(breed: breed)) {
                                CatsCard(breed: breed)
                            }
							.task{
								if index+1 < breeds.count {
									self.page+=1
									do {
										let breedsResult = try await breedsNetworkService.fetchBreeds(limitItemsPerPage, page)
										updateView(breeds: breedsResult)
									} catch {
										print("Erro on fetchBreeds")
									}
								}
							}
						}
                    }
                    .padding()

//					TextButton(
//						label: "Load more",
//						labelColor: .white,
//						rectangleColor: .blue,
//						action: {
//							Task {
//								do {
//									let result = try await breedsNetworkService.fetchBreeds(limitItemsPerPage, page)
//									for breed in result {
//										self.breeds.append(breed)
//									}
//								} catch {
//									print("Error on request")
//								}
//							}
//						}
//					)
//					.padding()
                }
                .navigationTitle("Breeds")
                .navigationBarTitleDisplayMode(.large)
                .searchable(text: $searchQuery)
            }
        }
		.onAppear(perform: {
			Task {
				let result = try await breedsNetworkService.fetchBreeds(limitItemsPerPage, page)
				updateView(breeds: result)
			}
		})
    }


	private func updateView(breeds : [BreedsData]) {
		print("6")
		for breed in breeds {
			self.breeds.append(breed)
		}
	}

}

struct BreedsView_Previews: PreviewProvider {
    static var previews: some View {
		BreedsView(breeds: .breedsMock)
    }
}
