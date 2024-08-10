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
    
    var modelContainer = try! ModelContainer(for: Breed.self, Weight.self, CatImage.self)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
        }
    }
}
