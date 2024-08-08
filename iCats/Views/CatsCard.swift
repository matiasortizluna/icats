//
//  CatsCard.swift
//  iCats
//
//  Created by Matias Luna on 05/08/2024.
//

import SwiftUI

struct CatsCard: View {
    @State private var isFavorite: Bool = false
    @EnvironmentObject private var viewModel: CatViewModel
    
    var body: some View {
        ZStack {
            VStack {
                ZStack(alignment: .topTrailing) {
                    if let url = viewModel.breeds.first?.image?.url {
                        AsyncImage(url: URL(string: url)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .padding(5)
                        } placeholder: {
                            Color.gray
                                .frame(width: 120, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .padding(5)
                        }
                        
                    } else {
                        Image("9rm")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(5)
                    }
                    
                    Button(action: {
                        self.isFavorite.toggle()
                    }) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 20.0))
                            .foregroundColor(isFavorite ? .yellow : .gray)
                            .padding(5)
                            .background(
                                Circle()
                                    .foregroundColor(.black.opacity(0.2))
                            )
                            .offset(x: -10, y: 10)
                    }
                }
                
                if let breedName = viewModel.breeds.first?.name {
                    Text(breedName)
                        .font(.system(size: 15))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                } else {
                    Text("Cat's Breed Name")
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(15)
            .shadow(radius: 5)
        }
    }
}

#Preview {
    CatsCard().environmentObject(CatViewModel())
}
