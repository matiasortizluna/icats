//
//  BreedsViewTests.swift
//  iCatsUITests
//
//  Created by Matias Luna on 12/08/2024.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import iCats

class BreedsViewTests: XCTestCase {
    
    func testLoadingState() throws {
            let view = BreedsView()
            
            let inspectedView = try view.inspect()
            
            let textView = try inspectedView.find(text: "Loading...")
            
            XCTAssertEqual(try textView.string(), "Loading...")
        }
}
