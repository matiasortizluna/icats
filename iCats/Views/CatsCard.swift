//
//  CatsCard.swift
//  iCats
//
//  Created by Matias Luna on 05/08/2024.
//

import SwiftUI

struct CatsCard: View {
    @State private var isFavorite : Bool = false
    
    var body: some View {
        VStack() {
            ZStack() {
                Image("9rm")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .padding()
                
                HStack() {
                    Spacer()
                    Spacer()
                    
                    Button(action: {
                        self.isFavorite.toggle()
                        
                    }, label: {
                        Image(systemName: "star.fill")
                            .font(.system(size: 50.0))
                            .foregroundColor( isFavorite ? .yellow : .gray)
                            .padding()
                            .overlay(content: {
                                
                                Circle()
                                    .foregroundColor(.black.opacity(0.2))
                                
                            })
                        
                    })
                    
                    Spacer()
                }
            }
            
            Text("Cat's Breed Name")
            
        }
        
    }
}

#Preview {
    CatsCard()
}
