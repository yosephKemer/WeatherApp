//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Yoseph Feseha on 3/1/23.
//

import Foundation

class NetworkManager {
    private let baseUrl = "https://api.openweathermap.org"
    private let apiKey = "53e417bf19fa3a041584c61a5b105c8c"
    
    
    func getWeatherData(cityName: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        let encodedCityName = cityName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let path = "/data/2.5/weather?q=\(encodedCityName)&appid=\(apiKey)"
        request(path: path, completion: completion)
    }

    private func request<T: Codable>(path: String, completion: @escaping (Result<T, Error>) -> Void) {
        let urlString = baseUrl + path
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

enum NetworkError: Error {
    case invalidUrl
    case noData
}
