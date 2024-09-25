//
//  CatImage.swift
//  iCats
//
//  Created by Matias Luna on 12/08/2024.
//

import SwiftData

@Model
class CatImageEntity {
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
