//
//  ContentView.swift
//  iCats
//
//  Created by Matias Luna on 05/08/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @EnvironmentObject var viewModel: BreedsViewModel
    
    var body: some View {
        TabView(selection: .constant(2)) {
            
            FavoriteBreedsView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
                .tag(1)
            
            BreedsView()
                .environmentObject(viewModel)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let previewModelContainer = try! ModelContainer(for: Breed.self, Weight.self, CatImage.self)
        
        ContentView()
            .modelContainer(previewModelContainer)
    }
}
