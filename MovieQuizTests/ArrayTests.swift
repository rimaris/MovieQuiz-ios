//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Мария Солодова on 22.12.2022.
//

import Foundation
import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    
    func testGetValueInRange() throws {
        // Given
        
        let arrayOfInt = [1, 2, 3, 4, 5]
        
        // When
        
        let value = arrayOfInt[safe: 2]
        
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 3)
        
    }
        
    func testGetValueOutOfRange() throws { 
        // Given
        let arrayOfInt = [1, 2, 3, 4, 5]
        
        // When
        let value = arrayOfInt[safe: 5]
        
        // Then
        XCTAssertNil(value)
    }
}

