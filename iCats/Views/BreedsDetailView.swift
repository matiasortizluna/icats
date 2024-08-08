import SwiftUI

struct BreedsDetailView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @State private var isFavorite: Bool = false
    var breed: Breed
    
    var body: some View {
        
        VStack(spacing: 15) {
            
            HStack {
                Spacer()
                Image(systemName: "star.fill")
                    .font(.system(size: 20.0))
                    .foregroundColor(isFavorite ? .yellow : .gray)
                    .padding(5)
                    .background(
                        Circle()
                            .foregroundColor(.black.opacity(0.2))
                    )
                    .offset(x: -10, y: 10)
                    .onTapGesture {
                        isFavorite.toggle()
                    }
            }
            
            ZStack {
                if let url = breed.image?.url {
                    AsyncImage(url: URL(string: url)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(5)
                    } placeholder: {
                        Color.gray
                            .frame(width: 120, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(5)
                    }
                } else {
                    Image("9rm")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(5)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(15)
            .shadow(radius: 5)
            
            HStack {
                Text(breed.origin)
                    .font(.title2)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    .shadow(radius: 5)
                
                Text(breed.temperament)
                    .font(.title2)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    .shadow(radius: 5)
            }
            
            Text(breed.description)
                .font(.title2)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .lineLimit(10)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .shadow(radius: 5)
            
            Spacer()
            
            Button(action: {
                isFavorite.toggle()
            }) {
                Text(isFavorite ? "Remove From Favorites" : "Add To Favorites")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                    .background(
                        Rectangle()
                            .foregroundColor(.yellow)
                            .cornerRadius(15.0)
                    )
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(15)
            .shadow(radius: 5)
        }
        .padding()
        .navigationTitle(breed.name)
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    BreedsDetailView(breed: Breed(id: "dasdsa", name: "Default", origin: "Default", temperament: "Default", description: "Default", lifeSpan: "Default", weight: Weight(imperial: "Default", metric: "Default"), image: nil, isFavorite: false))
}
