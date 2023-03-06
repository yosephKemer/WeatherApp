//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Yoseph Feseha on 2/28/23.
//

import XCTest
@testable import WeatherApp

class NetworkManagerTests: XCTestCase {

    var networkManager: NetworkManager!

    override func setUp() {
        super.setUp()
        networkManager = NetworkManager()
    }

    override func tearDown() {
        networkManager = nil
        super.tearDown()
    }

    func testGetWeatherData() {
        let expectation = self.expectation(description: "Get weather data expectation")
        let cityName = "London"
        networkManager.getWeatherData(cityName: cityName) { result in
            switch result {
            case .success(let weatherData):
                XCTAssertNotNil(weatherData)
            case .failure(let error):
                XCTFail("Failed to get weather data for \(cityName) with error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }

}
