//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Yoseph Feseha on 3/1/23.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    //UI Elements programatically
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Enter a city name"
        searchBar.delegate = self
        return searchBar
    }()
    
    private let lastCityNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica Neue", size: 16)
        label.textColor = .gray
        return label
    }()
    
    private let weatherDataLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica Neue", size: 20)
        label.textColor = .black
        return label
    }()
    
    private let fetchWeatherButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Fetch Weather", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 20)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(fetchWeatherData), for: .touchUpInside)
        
        return button
    }()
    
    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // view Model
    let viewModel = WeatherViewModel()
    
    // Location Manager
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(searchBar)
        view.addSubview(lastCityNameLabel)
        view.addSubview(fetchWeatherButton)
        view.addSubview(weatherDataLabel)
        view.addSubview(weatherIconImageView)  // If I had some more time I would try to do some work onthe UI part. Although I am showing all the required data, I can do better job with better job with UI of how I am showing the icons. Currently just showing them below the label.
        
        
        // function to setup all the UI
        setupUI()
        
        
        // Create the back button
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // Add the back button to the navigation bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        // Request location authorization
        setupLocationManager()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateViewData = { [weak self] (viewModel: WeatherViewModel) in
            self?.viewModelDidChange()
        }
        if let lastCityName = UserDefaults.standard.string(forKey: "lastCityName") {
            lastCityNameLabel.text = "Last City: \(lastCityName)"
        }
    }
    
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func setupUI() {
        
        
        // Search bar
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchBar.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // last city
        lastCityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lastCityNameLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            lastCityNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            lastCityNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // featch Weather btn
        fetchWeatherButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fetchWeatherButton.topAnchor.constraint(equalTo: lastCityNameLabel.bottomAnchor, constant: 20),
            fetchWeatherButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            fetchWeatherButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            fetchWeatherButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        weatherDataLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherDataLabel.topAnchor.constraint(equalTo: fetchWeatherButton.bottomAnchor, constant: 40),
            weatherDataLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            weatherDataLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Icon Image 
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherIconImageView.topAnchor.constraint(equalTo: weatherDataLabel.bottomAnchor, constant: 20),
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 100),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        if let lastCityName = viewModel.lastCityName {
            lastCityNameLabel.text = "Last City: \(lastCityName)"
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let padding: CGFloat = 20
        let labelWidth = view.bounds.width - padding * 2
        let labelX = padding
        let labelY = fetchWeatherButton.frame.maxY + padding * 2
        
        weatherDataLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: 0)
        weatherDataLabel.sizeToFit()
    }
    
    
    private func viewModelDidChange() {
        DispatchQueue.main.async { [self] in
            weatherDataLabel.text = viewModel.weatherDataText
            weatherIconImageView.image = viewModel.weatherIcon
            
            if let lastCityName = viewModel.lastCityName {
                lastCityNameLabel.text = "Last City: \(lastCityName)"
            }
            
            // Set the weather icon image
            weatherIconImageView.image = viewModel.weatherIcon
            
            if let errorText = viewModel.errorText {
                let alert = UIAlertController(title: "Error", message: errorText, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
            view.setNeedsLayout()
        }
    }
    
    // NetworkManager ==>
    @objc private func fetchWeatherData() {
        
        guard let cityName = searchBar.text?.trimmingCharacters(in: .whitespaces), !cityName.isEmpty else {
            showAlert(message: "Please enter a city name")
            return
        }
        
        
        viewModel.fetchWeatherData(cityName: cityName)
        lastCityNameLabel.text = "Last City: \(cityName)"
    }
    
    // Icons...
    private func loadWeatherIcon(from url: URL) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self?.weatherIconImageView.image = image
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    //Alert
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// SearchBar Delegate
extension WeatherViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let cityName = searchBar.text, !cityName.isEmpty else {
            showAlert(message: "Please enter a city name")
            return
        }
        viewModel.fetchWeatherData(cityName: cityName)
        lastCityNameLabel.text = "Last City: \(cityName)"
        searchBar.resignFirstResponder()
    }
}

// Location Manager
extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let placemark = placemarks?.first else { return }
            
            let cityName = placemark.locality ?? ""
            self?.searchBar.text = cityName
            // self?.fetchWeatherData(cityName: cityName)
            self?.viewModel.fetchWeatherData(cityName: cityName)
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user's location: \(error.localizedDescription)")
        //location test failed
    }
}
