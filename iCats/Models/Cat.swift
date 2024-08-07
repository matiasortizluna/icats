//
//  Cat.swift
//  iCats
//
//  Created by Matias Luna on 06/08/2024.
//

import Foundation

struct Cat: Decodable {
    let id: String
    let url: String
    let breedsName: String
    let breedsOrigin: String
    let breedsTemperament: String
    let breedsDescription: String
}

struct CatImage : Decodable {
    let id: String
    let url: String
    let width: Double
    let height: Double
}
