//
//  ContentView.swift
//  iCats
//
//  Created by Matias Luna on 05/08/2024.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView(selection: .constant(2)) {
            
            FavoriteBreedsView()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
                .tag(1)
            
            BreedsView()
                .tabItem {
                    Label("Breeds", systemImage: "cat")
                }
                .tag(2)
            
            AboutView()
                .tabItem {
                    Label("About", systemImage: "person")
                }
                .tag(3)
        }
        .accentColor(Color(.yellow))
    }
    
    
}

#Preview {
    ContentView()
        .environmentObject(CatViewModel())
}
