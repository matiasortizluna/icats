//
//  BreedTests.swift
//  iCatsTests
//
//  Created by Matias Luna on 12/08/2024.
//

import XCTest
@testable import iCats

final class BreedTests: XCTestCase {

    func testBreedInitialization() {
        let weight = Weight(imperial: "7  -  10", metric: "3 - 5")
        let catImage = CatImage(
            id: "0XYvRd7oD",
            width: 1204,
            height: 1445,
            url: "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg"
        )
        
        let breed = Breed(
            id: "abys",
            name: "Abyssinian",
            origin: "Egypt",
            temperament: "Active, Energetic, Independent, Intelligent, Gentle",
            description: "The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.",
            lifeSpan: "14 - 15",
            weight: weight,
            image: catImage,
            isFavorite: false
        )
        
        XCTAssertEqual(breed.id, "abys")
        XCTAssertEqual(breed.name, "Abyssinian")
        XCTAssertEqual(breed.origin, "Egypt")
        XCTAssertEqual(breed.temperament, "Active, Energetic, Independent, Intelligent, Gentle")
        XCTAssertEqual(breed.breedDescription, "The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.")
        XCTAssertEqual(breed.lifeSpan, "14 - 15")
        XCTAssertEqual(breed.weight.imperial, "7  -  10")
        XCTAssertEqual(breed.weight.metric, "3 - 5")
        XCTAssertEqual(breed.image?.id, "0XYvRd7oD")
        XCTAssertEqual(breed.isFavorite, false)
    }
}
