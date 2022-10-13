//
//  SearchLocationsViewController.swift
//  MyWeather
//
//  Created by Леонід Шевченко on 10.10.2022.
//

import UIKit

protocol SearchingLocationPickedDelegate: AnyObject {
    func searchLocationPicked(lat: Double, long: Double)
}

class SearchLocationsViewController: UIViewController, UISearchResultsUpdating {
    private let locationTableView: UITableView = {
        let value = UITableView()
        value.backgroundColor = .systemBackground.withAlphaComponent(0.7)
        value.translatesAutoresizingMaskIntoConstraints = false
        return value
    }()

    private var filteredLocations: [WeahterSearchResponse]? = []
    weak var delegate: SearchingLocationPickedDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpSearchTableView()
    }

    private func setUpSearchTableView() {
        locationTableView.register(LocationNameTableViewCell.self, forCellReuseIdentifier: LocationNameTableViewCell.identifier)
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
                DispatchQueue.main.async {
                    self.locationTableView.reloadData()
                }
            }
        }
    }
}

extension SearchLocationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredLocations?.count ?? 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = locationTableView.dequeueReusableCell(
                withIdentifier: LocationNameTableViewCell.identifier) as? LocationNameTableViewCell
        else {
            return UITableViewCell()
        }

        cell.configureLocationNameTVC(model: filteredLocations?[indexPath.row])
        cell.backgroundColor = .clear
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard
            var lat = filteredLocations?[indexPath.row].lat,
            var lon = filteredLocations?[indexPath.row].lon
        else {
            return
        }
        print("lat: \(lat) + lon: \(lon)")

        self.delegate?.searchLocationPicked(lat: lat, long: lon)
        self.dismiss(animated: true)

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}
