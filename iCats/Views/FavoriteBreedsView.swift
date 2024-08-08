//
//  FavoriteBreedsView.swift
//  iCats
//
//  Created by Matias Luna on 08/08/2024.
//

import SwiftUI

struct FavoriteBreedsView: View {
    var body: some View {
        NavigationView {
            Text("This is the Favorites Breed View")
            
                .navigationTitle("Favorite Breeds")
                .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    FavoriteBreedsView()
}
