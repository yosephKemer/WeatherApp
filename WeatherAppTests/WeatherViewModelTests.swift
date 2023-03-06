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

    func testFetchWeatherDataSuccess() {
        // Given from the requirment, 
        let cityName = "London"
    
//        let weatherData = WeatherData(
//                    main: WeatherMain(temp: 20.0, humidity: 50),
//                    weather: [Weather(description: "Cloudy", icon: "04d")]
//                )

        // When
        viewModel.fetchWeatherData(cityName: cityName)

        // Then
        XCTAssertEqual(viewModel.lastCityName, cityName)
        XCTAssertEqual(viewModel.weatherDataText, "Temperature: 20.0°C\nHumidity: 60%\nWeather: Cloudy")
        XCTAssertNotNil(viewModel.weatherIcon)
        XCTAssertNil(viewModel.errorText)
    }

    func testFetchWeatherDataFailure() {
        // Given
        let cityName = "InvalidCityName"
        let error = NetworkError.noData
        networkManager.mockError = error

        // When
        viewModel.fetchWeatherData(cityName: cityName)

        // Then
        XCTAssertEqual(viewModel.lastCityName, cityName)
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
