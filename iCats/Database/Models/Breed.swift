//
//  Breeds.swift
//  iCats
//
//  Created by Matias Luna on 10/08/2024.
//

import SwiftData

@Model
class Breed {
    let id: String
    let name: String
    let origin: String
    let temperament: String
    let breedDescription: String
    let lifeSpan: String
    let weight: Weight
    let image: CatImage?
    var isFavorite: Bool
    
    init(id: String, name: String, origin: String, temperament: String, description: String, lifeSpan: String, weight: Weight, image: CatImage?, isFavorite: Bool) {
        self.id = id
        self.name = name
        self.origin = origin
        self.temperament = temperament
        self.breedDescription = description
        self.lifeSpan = lifeSpan
        self.weight = weight
        self.image = image
        self.isFavorite = isFavorite
    }
    
}
