//
//  ContentView.swift
//  iCats
//
//  Created by Matias Luna on 05/08/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @EnvironmentObject private var viewModel: CatViewModel
    
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
    var body: some View {
        Text("Hello World, this is iCats")
            .font(.headline)
            .padding()
        
        if viewModel.breeds.isEmpty {
            Text("Loading...")
                .onAppear {
                    // Perform the fetch operation
                    viewModel.fetchBreeds()
                }
        } else {
            ScrollView() {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.breeds, id: \.id) { breed in
                        CatsCard(breed: breed)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(CatViewModel()) // Provide the view model in the preview
}
