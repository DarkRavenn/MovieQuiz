//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Aleksandr Dugaev on 22.04.2024.
//

import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        // Given ( Дано )
        let array = [1, 1, 2, 3, 5]
        
        // When ( Когда )
        let value = array[safe: 2]
        
        // Then ( Тогда )
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
        
    }
    
    func testGetValueOutRange() throws {
        // Given ( Дано )
        let array = [1, 1, 2, 3, 5]
        
        // When ( Когда )
        let value = array[safe: 20]
        
        // Then ( Тогда )
        XCTAssertNil(value)
        
    }
}
