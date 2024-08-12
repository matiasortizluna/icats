//
//  CatImageTests.swift
//  iCatsTests
//
//  Created by Matias Luna on 12/08/2024.
//

import XCTest
@testable import iCats

final class CatImageTests: XCTestCase {

    func testCatImageInitialization() {
        let catImage = CatImage(
            id: "0XYvRd7oD",
            width: 1204,
            height: 1445,
            url: "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg"
        )
        
        XCTAssertEqual(catImage.id, "0XYvRd7oD")
        XCTAssertEqual(catImage.width, 1204)
        XCTAssertEqual(catImage.height, 1445)
        XCTAssertEqual(catImage.url, "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg")
    }
    
}
