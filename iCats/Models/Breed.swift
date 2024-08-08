//
//  Cat.swift
//  iCats
//
//  Created by Matias Luna on 06/08/2024.
//

import Foundation

struct Breed: Identifiable {
    let id: String
    let name: String
    let origin: String
    let temperament: String
    let description: String
    let lifeSpan: String
    let weight: Weight
    let image: CatImage?
    let isFavorite : Bool?
}

struct Weight {
    let imperial: String
    let metric: String
}

struct CatImage {
    let id: String
    let width: Int
    let height: Int
    let url: String
}
