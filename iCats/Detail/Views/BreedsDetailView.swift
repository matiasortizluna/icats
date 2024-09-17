import SwiftUI
import SDWebImageSwiftUI

struct BreedsDetailView: View {
    
    var breed: BreedsData

    var body: some View {
        VStack() {
            ScrollView {
                ZStack(alignment: .topTrailing) {
//					if let url = breed.image.url {
                        WebImage(url: URL(string: breed.image.url)).resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(5)
                        
//                    } else {
//                        Image(systemName: "cat.fill")
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 200, height: 200)
//                            .clipShape(RoundedRectangle(cornerRadius: 15))
//                            .padding(5)
//                    }
                    
					SymbolButton(
						symbolLabel: "star.fill",
						symbolColor: .gray,
						backgroundColor: .black.opacity(0.2),
						action: {
//							breed.isFavorite.toggle()
						}
					)
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
                    
					Text(breed.description)
                        .font(.system(size: 15.0))
                        .lineLimit(nil)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                
                
                Spacer()
                
				TextButton(
					label: "Add To Favorites",
					labelColor: .black,
					rectangleColor: .yellow,
					action: {
//						breed.isFavorite.toggle()
					}
				)

            }
        }
        .padding(.horizontal)
        .navigationTitle(breed.name)
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    BreedsDetailView(
		breed: [BreedsData].breedsMock.first!
    )
}
