//
//  MainViewController.swift
//  MyWeather
//
//  Created by Леонід Шевченко on 22.09.2022.
//

import UIKit
import CoreLocation

// Location: CoreLocation
// tableView
// Custom cell: collectionView
// API / request to get the data

class MainViewController: UIViewController {
    enum Constants {
        static let apiKey = "8c898ee6ea2489277441ec97c87e467d"
    }

    private let table: UITableView = {
        let value = UITableView()
        value.backgroundColor = .blue
        return value
    }()

    private lazy var dailyModel = [Daily]()

    private let locationManager = CLLocationManager()

    private var currentLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()

        // register 2 cells
        table.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
        view.addSubview(table)
        table.delegate = self
        table.dataSource = self

        table.frame = view.bounds

        view.backgroundColor = .white
        title = "MyWeather"
        setUpLocation()
    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        NetworkManager.shared.requestDailyWeather { dailyModel in
//            self.dailyModel = dailyModel
//            self.table.reloadData()
//        }
//    }
}
// MARK: - Location SetUp
extension MainViewController: CLLocationManagerDelegate {
    private func setUpLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }

    private func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else { return }

        let lat = currentLocation.coordinate.latitude
        let long = currentLocation.coordinate.longitude

        let url = "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(long)&units=metric&exclude=minutely,alerts&appid=\(Constants.apiKey)"
        print("\(url)")

        guard
            let urlString = URL(string: url)
        else {
            debugPrint("Wrong URL ❌")
            return
        }

        URLSession.shared.dataTask(with: urlString, completionHandler: { data, response, error in
            // Validation
            guard let data = data, error == nil else {
                debugPrint("Something went wrong ❌")
                return
            }

            // Convert data to model / some object
            var json: WeatherResponse?
            do {
                json = try JSONDecoder().decode(WeatherResponse.self, from: data)
            } catch {
                debugPrint("Error: \(error) while decoding some data ❌ ")
            }

            guard let result = json else { return }

            print(String(describing: result.current?.pressure) + "🌡")

            // update user interface
        }).resume()
        print("🧭 \(lat) | \(long)")
    }
}

// MARK: - TableView SetUp
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dailyModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}

struct Weather {
}
