//
//  ContentView.swift
//  iCats
//
//  Created by Matias Luna on 05/08/2024.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        TabView() {
            FavoriteBreedsView()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
            
            BreedsView()
                .tabItem {
                    Label("Breeds", systemImage: "cat")
                }
            
            AboutView()
                .tabItem {
                    Label("About", systemImage: "person")
                }
        }
        .accentColor(Color(.yellow))
    }
    
    
}

#Preview {
    ContentView()
        .environmentObject(CatViewModel())
}
