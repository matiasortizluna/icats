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
    
    @StateObject private var viewModel = CatViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
