import SwiftUI
import SDWebImageSwiftUI

struct BreedsDetailView: View {
    
    var breed: Breed
    
    var body: some View {
        VStack() {
            ScrollView {
                ZStack(alignment: .topTrailing) {
                    if let url = breed.image?.url {
                        WebImage(url: URL(string: url)).resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(5)
                        
                    } else {
                        Image("9rm")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(5)
                    }
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 20.0))
                        .foregroundColor(breed.isFavorite ? .yellow : .gray)
                        .padding(5)
                        .background(
                            Circle()
                                .foregroundColor(.black.opacity(0.2))
                        )
                        .offset(x: -10, y: 10)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .shadow(radius: 5)
                
                VStack(alignment: .leading) {
                    Text("Origin")
                        .font(.system(size: 15.0))
                        .fontWeight(.bold)
                    
                    Text(breed.origin)
                        .font(.system(size: 15.0))
                        .lineLimit(nil)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                        .shadow(radius: 5)
                    
                    Text("Temperament")
                        .font(.system(size: 15.0))
                        .fontWeight(.bold)
                    
                    Text(breed.temperament)
                        .font(.system(size: 15.0))
                        .lineLimit(nil)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                        .shadow(radius: 5)
                    
                    Text("Description")
                        .font(.system(size: 15.0))
                        .fontWeight(.bold)
                    
                    Text(breed.breedDescription)
                        .font(.system(size: 15.0))
                        .lineLimit(nil)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                
                
                Spacer()
                
                
                Button(action: {
                    breed.isFavorite.toggle()
                }) {
                    Text(breed.isFavorite ? "Remove From Favorites" : "Add To Favorites")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .background(
                            Rectangle()
                                .foregroundColor(.yellow)
                                .cornerRadius(15.0)
                        )
                }
                .cornerRadius(15.0)
                .padding()
            }
        }
        .padding(.horizontal)
        .navigationTitle(breed.name)
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    BreedsDetailView(
        breed: Breed(
            id: "dasdsa",
            name: "Default",
            origin: "Default",
            temperament: "Default",
            description: "Default",
            lifeSpan: "Default",
            weight: Weight(imperial: "Default", metric: "Default"),
            image: nil,
            isFavorite: false
        )
    )
}
