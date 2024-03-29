//
//  MainViewController.swift
//  MyWeather
//
//  Created by Леонід Шевченко on 22.09.2022.
//

import UIKit
import CoreLocation
import Kingfisher

class MainViewController: UIViewController {
    // MARK: - Constants and Variables
    let table: UITableView = {
        let value = UITableView()
        value.separatorStyle = .none
        value.translatesAutoresizingMaskIntoConstraints = false
        return value
    }()

    private var headerImageView: UIImageView = {
        let value = UIImageView()
        return value
    }()

    private lazy var mapImage = UIImage(systemName: "map")
    private lazy var currentIconURLString = ""
    private lazy var localName: String? = ""
    private lazy var currentTemp: String? = ""
    private lazy var summary: String? = ""
    private lazy var minTempLabel: String? = ""
    private lazy var maxTampLabel: String? = ""
    private lazy var currentDateLabel: String? = ""
    private lazy var sunriseTimeLabel: String? = ""
    private lazy var sunsetTimeLabel: String? = ""
    private lazy var humidityLabel: String? = ""

    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private let defaults = UserDefaults.standard

    private var lat = Double()
    private var long = Double()

    private let searchController = UISearchController(searchResultsController: SearchLocationsViewController())
    private var isSearchBarEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
            return text.isEmpty
    }
    private var isFiltering: Bool {
        searchController.isActive && !isSearchBarEmpty
    }

    private var dailyModel = [Daily]()
    private var hourlyModels = [Hourly]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        setUpTableView()
        setUpLocation()
        setUpSerachController()
    }

    // MARK: - functions
    private func setUpSerachController() {
        let resultVC = SearchLocationsViewController()
        let searchController = UISearchController(searchResultsController: resultVC)
        searchController.searchResultsUpdater = resultVC
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for location"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        resultVC.delegate = self
    }

    private func setUpUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: mapImage,
            style: .plain,
            target: self,
            action: #selector(goToMapViewController)
        )
        view.backgroundColor = .systemBackground
    }

    @objc func goToMapViewController(sender: AnyObject) {
        let mapVC = MapViewController()
        mapVC.delegate = self
        let navController = UINavigationController(rootViewController: mapVC)
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }

    private func setUpTableView() {
        table.register(HourlyWeatherTableViewCell.self, forCellReuseIdentifier: HourlyWeatherTableViewCell.identifier)
        table.register(DailyWeatherTableViewCell.self, forCellReuseIdentifier: DailyWeatherTableViewCell.identifier)
        view.addSubview(table)
        table.delegate = self
        table.dataSource = self

        table.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
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
            requestWeatherForLocation(lat: currentLocation?.coordinate.latitude, long: currentLocation?.coordinate.longitude)
        }
    }

    private func requestWeatherForLocation(lat: Double?, long: Double?) {
        AnimatedViewManager.shared.showIndicator(.weatherLoading)
        guard let lat = lat else { return }
        guard let long = long else { return }

        self.lat = lat
        self.long = long
        defaults.set(lat, forKey: "lat")
        defaults.set(long, forKey: "long")
        print(lat)
        print(long)

        // MARK: - URL weather's data response for getting data for current + hourly + daily objects
        APIService.shared.getWeatherData(lat: lat, lon: long) { json, error in
            if let result = json {

                guard let dailyEntries = result.daily else { return }

                guard let currentEntries = result.current else { return }

                guard let hourlyEntries = result.hourly else { return }

                self.hourlyModels = hourlyEntries

                if !self.dailyModel.isEmpty {
                    self.dailyModel.removeAll()
                }

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

                // Update user interface after header image will be downloaded
                DispatchQueue.main.async {
                    self.headerImageView.kf.indicatorType = .activity
                    self.headerImageView.kf.setImage(
                        with: URL(string: currentIconURL),
                        placeholder: nil,
                        options: [.transition(.fade(0.5))],
                        progressBlock: nil) { result in
                            switch result {
                            case .success(_):
                                AnimatedViewManager.shared.hide()
                                self.table.tableHeaderView = self.setUpHeaderView()
                                self.table.reloadData()
                            case .failure(_):
                                print("failure")
                            }
                    }
                }
            }
        }

        // MARK: - URL geo data response for getting location name in headerView
        APIService.shared.getGeoData(lat: lat, lon: long) { json, error in
            if let cityNames = json {
                self.localName = cityNames.first?.name

                DispatchQueue.main.async {
                    self.table.tableHeaderView = self.setUpHeaderView()
                    self.table.reloadData()
                }
            }
        }
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
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }

        return dailyModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard
                let cell = table.dequeueReusableCell(
                    withIdentifier: HourlyWeatherTableViewCell.identifier,
                    for: indexPath)
                    as? HourlyWeatherTableViewCell
            else {
                return UITableViewCell()
            }

            cell.configure(with: hourlyModels)
            cell.selectionStyle = .none
            return cell
        }

        guard
            let cell = table.dequeueReusableCell(
                withIdentifier: DailyWeatherTableViewCell.identifier,
                for: indexPath)
                as? DailyWeatherTableViewCell
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

// MARK: - Protocol Delegate Methods
extension MainViewController: MapVCPickedLocationDelegate {
    func mapPickedLocation(lat: Double, long: Double) {
        requestWeatherForLocation(lat: lat, long: long)
    }
}

extension MainViewController: SearchingLocationPickedDelegate {
    func searchLocationPicked(lat: Double, long: Double) {
        requestWeatherForLocation(lat: lat, long: long)
    }
}
