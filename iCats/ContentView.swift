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
    
    var body: some View {
        Text("Hello World, this is iCats")
            .font(.headline)
            .padding()
        
        CatsCard()
        
        if viewModel.catsIDs.isEmpty {
            Text("Loading...")
                .onAppear {
                    // Perform the fetch operation
                    viewModel.fetchCatsIDs()
                }
        } else {
            ForEach(viewModel.catsIDs, id: \.self) { catID in
                Text(catID)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(CatViewModel()) // Provide the view model in the preview
}
