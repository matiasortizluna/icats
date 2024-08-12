//
//  iCatsApp.swift
//  iCats
//
//  Created by Matias Luna on 05/08/2024.
//

import SwiftUI
import SwiftData

@main
struct iCatsApp: App {
    
    private var modelContainer: ModelContainer
    @StateObject private var viewModel: BreedsViewModel
    
    init() {
        // Initialize ModelContainer
        modelContainer = try! ModelContainer(for: Breed.self, Weight.self, CatImage.self)
        
        // Extract ModelContext from ModelContainer
        let modelContext = modelContainer.mainContext
        
        // Initialize the view model with the ModelContext
        _viewModel = StateObject(wrappedValue: BreedsViewModel(modelContext: modelContext))
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .modelContainer(modelContainer)
        }
    }
}
