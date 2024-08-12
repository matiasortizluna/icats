//
//  CatsCard.swift
//  iCats
//
//  Created by Matias Luna on 05/08/2024.
//

import SwiftUI
import SwiftData
import SDWebImageSwiftUI

struct CatsCard: View {
    var breed : Breed
    
    var body: some View {
        ZStack {
            VStack {
                ZStack(alignment: .topTrailing) {
                    if let url = breed.image?.url {
                        WebImage(url: URL(string: url)).resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(5)
                    }
                    
                    Button(action: {
                        breed.isFavorite.toggle()
                        
                    }) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 20.0))
                            .foregroundColor(breed.isFavorite ? .yellow : .gray)
                            .padding(5)
                            .background(
                                Circle()
                                    .foregroundColor(.black.opacity(0.2))
                            )
                            .offset(x: -10, y: 10)
                    }
                }
                
                Text(breed.name)
                    .font(.system(size: 15))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(15)
            .shadow(radius: 5)
        }
    }
}

#Preview {
    CatsCard(
        breed: Breed(id: "dasdsa", name: "Default", origin: "Default", temperament: "Default", description: "Default", lifeSpan: "Default", weight: Weight(imperial: "Default", metric: "Default"), image: nil, isFavorite: false
                    ))
}
