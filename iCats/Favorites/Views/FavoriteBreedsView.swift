//
//  FavoriteBreedsView.swift
//  iCats
//
//  Created by Matias Luna on 08/08/2024.
//

import SwiftUI
import SwiftData

struct FavoriteBreedsView: View {

    var favoriteBreeds: [BreedsData] = []

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
                            NavigationLink(destination: BreedsDetailView(breed: breed)) {
                                CatsCard(breed: breed)
                            }
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
    FavoriteBreedsView()
}
