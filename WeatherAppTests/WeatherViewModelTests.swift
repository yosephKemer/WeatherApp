//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Yoseph Feseha on 3/5/23.
//

import Foundation
import XCTest
@testable import WeatherApp


class WeatherViewModelTests: XCTestCase {

    var networkManager: MockNetworkManager!
    var viewModel: WeatherViewModel!
    
    override func setUp() {
        super.setUp()
        networkManager = MockNetworkManager()
        viewModel = WeatherViewModel(networkManager: networkManager)
    }

    override func tearDown() {
        networkManager = nil
        viewModel = nil
        super.tearDown()
    }


    func testFetchWeatherDataFailure() {

        let cityName = "InvalidCityName"
        let error = NetworkError.noData
        networkManager.mockError = error

        viewModel.fetchWeatherData(cityName: cityName)

        XCTAssertNil(viewModel.weatherDataText)
        XCTAssertNil(viewModel.weatherIcon)
        XCTAssertEqual(viewModel.errorText, error.localizedDescription)
    }
}

class MockNetworkManager: NetworkManager {
    var mockWeatherData: WeatherData?
    var mockError: Error?

    override func getWeatherData(cityName: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        if let mockWeatherData = mockWeatherData {
            completion(.success(mockWeatherData))
        } else if let mockError = mockError {
            completion(.failure(mockError))
        }
    }
}
