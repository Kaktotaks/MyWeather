//
//  ResultLocationsViewController.swift
//  MyWeather
//
//  Created by Леонід Шевченко on 10.10.2022.
//

import UIKit

class ResultLocationsViewController: UIViewController, UISearchResultsUpdating {
    private let locationTableView: UITableView = {
        let value = UITableView()
        value.backgroundColor = UIColor(white: 0.3, alpha: 0.8)
        value.translatesAutoresizingMaskIntoConstraints = false
        return value
    }()

    private var filteredLocations = [WeahterSearchResponse]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpSearchTableView()
    }

    // 🔍
    private func setUpSearchTableView() {
        locationTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(locationTableView)
        locationTableView.delegate = self
        locationTableView.dataSource = self
        locationTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard
            let query = searchController.searchBar.text
        else {
            return
        }

        APIService.shared.getLocationsByName(for: query.trimmingCharacters(in: .whitespaces)) { locations, error in
            if let locations = locations {
                self.filteredLocations = locations
                //                self.filteredLocations.append(contentsOf: locations)
                //                self.filteredLocations = locations.filter { (location: WeahterSearchResponse) -> Bool in
                //                    return location.name?.contains(query) ?? true
                DispatchQueue.main.async {
                    self.locationTableView.reloadData()
                }
            }
        }
    }
}

extension ResultLocationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = locationTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filteredLocations[indexPath.row].name

        return cell
    }
}
