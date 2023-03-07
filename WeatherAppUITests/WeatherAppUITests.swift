//
//  WeatherAppUITests.swift
//  WeatherAppUITests
//
//  Created by Yoseph Feseha on 2/28/23.
//

import XCTest

class WeatherAppUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testWeatherApp() throws {
        // Test the initial view
        
        XCTAssert(app.staticTexts["Weather App"].exists)
        XCTAssert(app.staticTexts["iOS Assessment\nby\nYoseph Feseha"].exists)
        XCTAssert(app.buttons["Start"].exists)
        
        // Tap the "Start" button
        app.buttons["Start"].tap()
        
        // Type in a city name and tap the "Fetch Weather" button
        let searchBar = app.searchFields["Enter a city name"]
        searchBar.tap()
        searchBar.typeText("New York\n")

        // Find and tap the "Fetch Weather" button
        let fetchWeatherButton = app.buttons["Fetch Weather"]
        fetchWeatherButton.tap()
   
    }
}
