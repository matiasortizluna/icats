//
//  AboutView.swift
//  iCats
//
//  Created by Matias Luna on 08/08/2024.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        
        NavigationView {
            Text("This is the About View")
            
                .navigationTitle("About")
                .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    AboutView()
}
