//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Мария Солодова on 23.12.2022.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    // swiftlint:disable:next implicitly_unwrapped_optional
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false

    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
//    func testYesButton() {
//        let firstPoster = app.images["Poster"]
//
//        app.buttons["Yes"].tap()
//
//        let secondPoster = app.images["Poster"]
//        let indexLabel = app.staticTexts["Index"]
//
//        sleep(5)
//
//        XCTAssertTrue(indexLabel.label == "2/10")
//        XCTAssertFalse(firstPoster == secondPoster)
//
//    }
    
    func testNoButton() {
        let firstPoster = app.images["Poster"]
        app.buttons["No"].tap()
        
        let secondPoster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]
        
        sleep(5)
        
        XCTAssertTrue(indexLabel.label == "2/10")
        XCTAssertFalse(firstPoster == secondPoster)
    }
    
    func testGameFinish() {
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(1)
        }
        sleep(2)
        
        let alert = app.alerts["Game results"]
        
        XCTAssertTrue(app.alerts["Game results"].exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
    }
    
    func testAlertDismiss() {
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(1)
        }
        
        sleep(2)
        
        let alert = app.alerts["Game results"]
        
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(app.alerts["Game results"].exists)
        XCTAssertTrue(indexLabel.label == "1/10")
        
    }

}
