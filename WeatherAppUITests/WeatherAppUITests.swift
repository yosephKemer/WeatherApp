//
//  WeatherAppUITests.swift
//  WeatherAppUITests
//
//  Created by Yoseph Feseha on 2/28/23.
//

import XCTest



final class WeatherAppUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testWeatherViewController() throws {
        let startButton = app.buttons["Start"]
        XCTAssertTrue(startButton.exists)
        startButton.tap()
        
        let searchBar = app.searchFields.firstMatch
        XCTAssertTrue(searchBar.exists)
        searchBar.tap()
        searchBar.typeText("New York")
        app.keyboards.buttons["Search"].tap()
        
        let weatherDataLabel = app.staticTexts["weatherDataLabel"]
        let weatherIconImageView = app.images["weatherIconImageView"]
        XCTAssertTrue(weatherDataLabel.waitForExistence(timeout: 10))
        XCTAssertTrue(weatherIconImageView.waitForExistence(timeout: 10))
        
        app.navigationBars.buttons.firstMatch.tap()
        XCTAssertTrue(startButton.exists)
    }
}

