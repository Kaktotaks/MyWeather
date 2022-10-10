//
//  ResultLocationsViewController.swift
//  MyWeather
//
//  Created by Леонід Шевченко on 10.10.2022.
//

import UIKit

class ResultLocationsViewController: UIViewController {
    private let locationTableView: UITableView = {
        let value = UITableView()
        value.translatesAutoresizingMaskIntoConstraints = false
        return value
    }()

    private var searchText: String?

    private var filteredLocations: [WeatherGeoResponse] = [] // Виправити на нову модель

    override func viewDidLoad() {
        super.viewDidLoad()

        let mainVC = MainViewController()
        mainVC.sendSearchQueryTextDelegate = self

        setUpSearchTableView()
    }

    // 🔍
    private func setUpSearchTableView() {
        locationTableView.register(LocationNameTableViewCell.self, forCellReuseIdentifier: LocationNameTableViewCell.identifier)
        view.addSubview(locationTableView)
        locationTableView.delegate = self
        locationTableView.dataSource = self

        locationTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension ResultLocationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = locationTableView.dequeueReusableCell(withIdentifier: LocationNameTableViewCell.identifier, for: indexPath)
        cell.textLabel?.text = "Test"

        return cell
    }
}

extension ResultLocationsViewController: SearchQueryDelegate {
    func sendSearchQueryText(text: String) {
        debugPrint("Delegate is working, searching for - \(text) 👍🏼")
    }
}
