import SwiftUI
import SwiftyJSON
import SwiftData

struct BreedsView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var breeds: [Breed]
    
    @State private var searchQuery: String = ""
    
    var filteredBreeds: [Breed] {
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
            if breeds.isEmpty {
                Text("Loading...")
                    .onAppear {
                        self.fetchBreeds()
                    }
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(filteredBreeds, id: \.id) { breed in
                            NavigationLink(destination: BreedsDetailView(breed: breed)) {
                                CatsCard(breed: breed)
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle("Breeds")
                .navigationBarTitleDisplayMode(.large)
                .searchable(text: $searchQuery)
            }
        }
    }
    
    private func fetchBreeds() {
        
        let apiKey = "live_ISll8gOWarTBCiBssIqrzkvhzuez2g72xz4WzKx1BkRLXoWIlXD1GTKNklz1ERUr"
        let urlString = "https://api.thecatapi.com/v1/breeds?limit=20&page=0"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            defer {
                semaphore.signal()
            }
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            print("Data received: \(data)")
            
            do {
                let json = try JSON(data: data)
                
                for item in json.arrayValue {
                    
                    let breed = Breed(
                        id: item["id"].stringValue,
                        name: item["name"].stringValue,
                        origin: item["origin"].stringValue,
                        temperament: item["temperament"].stringValue,
                        description: item["description"].stringValue,
                        lifeSpan: item["life_span"].stringValue,
                        weight: Weight(imperial: item["weight"]["imperial"].stringValue,
                                       metric: item["weight"]["metric"].stringValue),
                        image: item["image"].exists() ? CatImage(
                            id: item["image"]["id"].stringValue,
                            width: item["image"]["width"].intValue,
                            height: item["image"]["height"].intValue,
                            url: item["image"]["url"].stringValue
                        ) : nil,
                        isFavorite: false
                    )
                    
                    DispatchQueue.main.async {
                        self.modelContext.insert(breed)
                    }
                }
                
            } catch {
                print("JSON decoding error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
        semaphore.wait()
    }
}

struct BreedsView_Previews: PreviewProvider {
    static var previews: some View {
        let previewModelContainer = try! ModelContainer(for: Breed.self, Weight.self, CatImage.self)
        
        BreedsView()
            .modelContainer(previewModelContainer)
    }
}
