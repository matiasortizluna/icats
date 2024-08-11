//
//  Weight.swift
//  iCats
//
//  Created by Matias Luna on 11/08/2024.
//

import SwiftData

@Model
class Weight {
    let imperial: String
    let metric: String
    
    init(imperial: String, metric: String) {
        self.imperial = imperial
        self.metric = metric
    }
}
