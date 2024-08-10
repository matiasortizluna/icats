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
    let weight: WeightJSON
    let image: CatImageJSON?
    let isFavorite: Bool
    
    init(id: String, name: String, origin: String, temperament: String, description: String, lifeSpan: String, weight: WeightJSON, image: CatImageJSON?, isFavorite: Bool) {
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

@Model
class Weights {
    let imperial: String
    let metric: String
    
    init(imperial: String, metric: String) {
        self.imperial = imperial
        self.metric = metric
    }
}

@Model
class CatImages {
    let id: String
    let width: Int
    let height: Int
    let url: String
    
    init(id: String, width: Int, height: Int, url: String) {
        self.id = id
        self.width = width
        self.height = height
        self.url = url
    }
}
