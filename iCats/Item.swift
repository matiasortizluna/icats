//
//  Item.swift
//  iCats
//
//  Created by Matias Luna on 05/08/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
