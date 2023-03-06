//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Yoseph Feseha on 3/3/23.
//
//

import UIKit

class WeatherViewModel {
    
    // Dependencies
    private let networkManager: NetworkManager
    
    // View data
    private(set) var weatherDataText: String?
    private(set) var errorText: String?
    private(set) var lastCityName: String? {
        didSet {
            UserDefaults.standard.set(lastCityName, forKey: "lastCityName")
        }
    }
    private(set) var weatherIcon: UIImage?
    
    // Callbacks
    var updateViewData: ((WeatherViewModel) -> Void)?
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
        self.lastCityName = UserDefaults.standard.string(forKey: "lastCityName")
    }
    
    func fetchWeatherData(cityName: String) {
        networkManager.getWeatherData(cityName: cityName) { [weak self] result in
            switch result {
            case .success(let weatherData):
                let temp = String(format: "%.1f", 1.8 * (weatherData.main.temp - 273) + 32)
                self?.weatherDataText = "Temperature: \(temp)°F\nHumidity: \(weatherData.main.humidity)%\nWeather: \(weatherData.weather.first?.description ?? "")"
                self?.errorText = nil
                
                // Download the weather icon image
                if let iconCode = weatherData.weather.first?.icon {
                    self?.downloadWeatherIcon(iconCode: iconCode)
                }
                
                self?.updateViewData?(self!)
                self?.lastCityName = cityName
            case .failure(let error):
                self?.weatherDataText = nil
                self?.errorText = error.localizedDescription
                self?.updateViewData?(self!)
            }
        }
    }
    
    private func downloadWeatherIcon(iconCode: String) {
        let imageUrlString = "https://openweathermap.org/img/w/\(iconCode).png"
        
        guard let imageUrl = URL(string: imageUrlString) else {
            print("Invalid image URL: \(imageUrlString)")
            return
        }
        
        URLSession.shared.dataTask(with: imageUrl) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                print("Failed to download weather icon: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let image = UIImage(data: data) {
                self?.weatherIcon = image
                self?.updateViewData?(self!)
            } else {
                print("Failed to create image from downloaded data")
            }
        }.resume()
    }
}
