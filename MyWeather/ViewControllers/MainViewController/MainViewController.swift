//
//  MainViewController.swift
//  MyWeather
//
//  Created by Леонід Шевченко on 22.09.2022.
//

import UIKit
import CoreLocation
import Kingfisher

// Location: CoreLocation
// tableView
// Custom cell: collectionView
// API / request to get the data

class MainViewController: UIViewController {
    private let table: UITableView = {
        let value = UITableView()
        value.separatorStyle = .none
        value.translatesAutoresizingMaskIntoConstraints = false
        return value
    }()

    private var headerImageView: UIImageView = {
        let value = UIImageView()
        return value
    }()

    private var dailyModel = [Daily]()
    private var currentIconURLString = ""
    private var localName: String?
    private var currentTemp: String?
    private var summary: String?
    private var minTempLabel: String?
    private var maxTampLabel: String?
    private var currentDateLabel: String?
    private var sunriseTimeLabel: String?
    private var sunsetTimeLabel: String?
    private var humidityLabel: String?

    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
        setUpLocation()
    }

    private func setUpTableView() {
        table.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
        view.addSubview(table)
        table.delegate = self
        table.dataSource = self

        table.snp.makeConstraints {
            $0.leftMargin.rightMargin.bottomMargin.topMargin.equalToSuperview()
        }
    }
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
            currentLocation = locations.last
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }

    private func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else { return }

        let lat = currentLocation.coordinate.latitude
        let long = currentLocation.coordinate.longitude
        print(lat)
        print(long)

        let dataURL = "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(long)&units=metric&exclude=minutely,alerts&appid=\(Constants.apiKey)"

        let geoURL = "http://api.openweathermap.org/geo/1.0/reverse?lat=\(lat)&lon=\(long)&limit=5&appid=\(Constants.apiKey)"

        guard
            let dataUrlString = URL(string: dataURL),
            let geoURLString = URL(string: geoURL)
        else {
            debugPrint("Wrong URL ❌")
            return
        }

        // MARK: - URL data response
        URLSession.shared.dataTask(with: dataUrlString, completionHandler: { data, response, error in
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

            guard let dailyEntries = result.daily else { return }

            guard let currentEntries = result.current else { return }

            self.dailyModel.append(contentsOf: dailyEntries)

            self.currentTemp = "🌡" + String(describing: Int(currentEntries.temp ?? 0.0)) + "°"
            self.summary = currentEntries.weather?.first?.description
            self.minTempLabel = "⇣" + String(describing: Int(dailyEntries.first?.temp?.min ?? 0.0)) + "°"
            self.maxTampLabel = "⇡" + String(describing: Int(dailyEntries.first?.temp?.max ?? 0.0)) + "°"
            self.currentDateLabel = DateFormaterManager.shared.formatDate(
                date: Date(timeIntervalSince1970: Double(currentEntries.dt ?? 0)),
                dateFormat: Constants.DateFormats.date
            )
            self.sunsetTimeLabel = "🌙 " + DateFormaterManager.shared.formatDate(
                date: Date(timeIntervalSince1970: Double(currentEntries.sunset ?? 0)),
                dateFormat: Constants.DateFormats.hourMinute
            )
            self.sunriseTimeLabel = "🌞 " + DateFormaterManager.shared.formatDate(
                date: Date(timeIntervalSince1970: Double(currentEntries.sunrise ?? 0)),
                dateFormat: Constants.DateFormats.hourMinute
            )
            self.humidityLabel = "💧" + String(describing: Int(currentEntries.humidity ?? Int(0.0))) + "%"
            

            let currentIcon = currentEntries.weather?.first?.icon
            var currentIconURL = "http://openweathermap.org/img/wn/\(currentIcon ?? "03d")@2x.png"

            // Update user interface after image will be downloaded
            DispatchQueue.main.async {
                self.headerImageView.kf.indicatorType = .activity
                self.headerImageView.kf.setImage(with: URL(string: currentIconURL), placeholder: nil, options: [.transition(.fade(0.5))], progressBlock: nil) { result in
                    switch result {
                    case .success(_):
                        self.table.tableHeaderView = self.setUpHeaderView()
                        self.table.reloadData()
                    case .failure(_):
                        print("failure")
                    }
                }
            }
        }).resume()

        // MARK: - URL geo data response
        URLSession.shared.dataTask(with: geoURLString, completionHandler: { data, response, error in
            // Validation
            guard let data = data, error == nil else {
                debugPrint("Something went wrong ❌")
                return
            }

            // Convert data to model / some object
            var json: [WeatherGeoResponse]?

            do {
                json = try JSONDecoder().decode([WeatherGeoResponse].self, from: data)
            } catch {
                debugPrint("Error: \(error) while decoding some geo data ❌ ")
            }
            print(json?.first?.localNames?.en as Any)

            self.localName = json?.first?.localNames?.en
            // update user interface
            DispatchQueue.main.async {
                self.table.tableHeaderView = self.setUpHeaderView()
                self.table.reloadData()
            }
        }).resume()
    }

// MARK: - TableViewHeader SetUp
    private func setUpHeaderView() -> UIView {
        let header = MainViewTableHeaderView(frame: CGRect(
            x: 0,
            y: 0,
            width: view.frame.size.width,
            height: CGFloat(300)))

        header.locationLabel.text = localName
        header.currentWeatherTempLabel.text = self.currentTemp
        header.descriptionLabel.text = self.summary
        header.maxTempLabel.text = self.maxTampLabel
        header.minTempLabel.text = self.minTempLabel
        header.currentWeatherImageView.image = self.headerImageView.image
        header.currentDateLabel.text = self.currentDateLabel
        header.sunriseTimeLabel.text = self.sunriseTimeLabel
        header.sunsetTimeLabel.text = self.sunsetTimeLabel
        header.humidityLabel.text = self.humidityLabel
        return header
    }
}

// MARK: - TableView SetUp
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dailyModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = table.dequeueReusableCell(
                withIdentifier: WeatherTableViewCell.identifier,
                for: indexPath)
                as? WeatherTableViewCell
        else {
            return UITableViewCell()
        }

        cell.configure(with: dailyModel[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }

    // Appearing cells animation
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 150, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        UIView.animate(withDuration: 1.0) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
}
