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
            VStack() {
                Text("This app was developed by Matias Luna on August 2024 as a Swift Challenge for the Mobile Engineer Trainee Role at Sword Health.")
                    .foregroundColor(.black)
                    .padding()
                
                Text("Thanks for downloading and testing.")
                    .foregroundColor(.black)
                    .padding()
                
                Text("For inquiries please contact the developer at:")
                    .foregroundColor(.black)
                    .padding()
                
                Text("matiasortizluna.contacto@gmail.com")
                    .foregroundColor(.black)
                    .padding()
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    AboutView()
}
