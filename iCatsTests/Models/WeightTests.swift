//
//  WeightTests.swift
//  iCatsTests
//
//  Created by Matias Luna on 12/08/2024.
//

import XCTest
@testable import iCats

final class WeightTests: XCTestCase {

    func testWeightInitialization() {
        let weight = Weight(imperial: "7  -  10", metric: "3 - 5")
        
        XCTAssertEqual(weight.imperial, "7  -  10")
        XCTAssertEqual(weight.metric, "3 - 5")
    }
    
}
