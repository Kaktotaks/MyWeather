//
//  MapSearchVC.swift
//  MyWeather
//
//  Created by Леонід Шевченко on 24.10.2022.
//

import UIKit
import SnapKit
import CoreLocation
import SkyFloatingLabelTextField

protocol MapSearchDelegate: AnyObject {
    func mapSearchVCLocationPicked(_ vc: MapSearchVC, didSelectLocationWith coordinates: CLLocationCoordinate2D?)
}

class MapSearchVC: UIViewController {
    private lazy var mapTypeDescriptionLabel: UILabel = {
        let value = UILabel()
        value.contentMode = .left
        value.font = Constants.Fonts.mediumFont
        value.text = "Choose map style"
        return value
    }()

    private lazy var locationNameTextField: SkyFloatingLabelTextField = {
        let value = SkyFloatingLabelTextField()
        value.placeholder = "Search location by name"
        value.title = "Location name"
        value.titleFadeInDuration = 2
        value.selectedTitleColor = .systemGray
        value.font = UIFont.systemFont(ofSize: 24)
        value.autocapitalizationType = .none
        value.leftViewMode = .always
        value.becomeFirstResponder()
        return value
    }()

    private lazy var latitudeTextField: SkyFloatingLabelTextField = {
        let value = SkyFloatingLabelTextField()
        value.placeholder = "Paste latitude"
        value.title = "Latitude"
        value.titleFadeInDuration = 2
        value.selectedTitleColor = .systemGray
        value.font = UIFont.systemFont(ofSize: 20)
        value.autocapitalizationType = .none
        value.leftViewMode = .always
        return value
    }()

    private lazy var longitudeTextField: SkyFloatingLabelTextField = {
        let value = SkyFloatingLabelTextField()
        value.placeholder = "Paste longitude"
        value.title = "Longitude"
        value.titleFadeInDuration = 2
        value.selectedTitleColor = .systemGray
        value.font = UIFont.systemFont(ofSize: 20)
        value.autocapitalizationType = .none
        value.leftViewMode = .always
        return value
    }()

    private let locationsTableView: UITableView = {
        let value = UITableView()
        value.backgroundColor = .clear
        value.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
        return value
    }()

    private var locations = [Location]()

    weak var delegate: MapSearchDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .secondarySystemBackground.withAlphaComponent(0.8)
        locationNameTextField.delegate = self
        latitudeTextField.delegate = self
        longitudeTextField.delegate = self
        locationsTableView.delegate = self
        locationsTableView.dataSource = self
        setupConstraint()
    }

    private func setupConstraint() {
        view.addSubview(locationNameTextField)
        view.addSubview(latitudeTextField)
        view.addSubview(longitudeTextField)
        view.addSubview(locationsTableView)

        // TextField settings
        locationNameTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(12)
            $0.height.equalTo(60)
        }

        latitudeTextField.snp.makeConstraints {
            $0.top.equalTo(locationNameTextField).offset(80)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide).inset(12)
            $0.width.equalToSuperview().dividedBy(2.2)
            $0.height.equalTo(40)
        }

        longitudeTextField.snp.makeConstraints {
            $0.top.equalTo(locationNameTextField).offset(80)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(12)
            $0.width.equalToSuperview().dividedBy(2.2)
            $0.height.equalTo(40)
        }

        // TableView settings
        locationsTableView.snp.makeConstraints {
            $0.top.equalTo(latitudeTextField).offset(80)
            $0.leading.equalTo(latitudeTextField)
            $0.trailing.equalTo(longitudeTextField)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

extension MapSearchVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let latitudeText = latitudeTextField.text else { return false }
        guard let longitudeText = longitudeTextField.text else { return false }
        guard let cityNameText = locationNameTextField.text else { return false }

        if !cityNameText.isEmpty {
            LocationManager.shared.findLocations(with: cityNameText) { [weak self] locations in
                DispatchQueue.main.async {
                    self?.locations = locations
                    self?.locationsTableView.reloadData()
                }
            }
        }

        if !latitudeText.isEmpty && !longitudeText.isEmpty  {
            print("Searching by lat and lon ✅")

            LocationManager.shared.findLocationsByCoordinates(
                lat: Double(latitudeText) ?? 0.0,
                lon: Double(longitudeText) ?? 0.0) { [weak self] locations in
                DispatchQueue.main.async {
                    self?.locations = locations
                    self?.locationsTableView.reloadData()
                }
            }
        }

        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if locationNameTextField.isHighlighted {
            latitudeTextField.text?.removeAll()
            longitudeTextField.text?.removeAll()
        }

        if latitudeTextField.isHighlighted || longitudeTextField.isHighlighted {
            locationNameTextField.text?.removeAll()
        }
        return true
    }
}

extension MapSearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        cell.textLabel?.text = locations[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        cell.backgroundColor = .clear
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Notify map controller to show pin at selected place
        let coordinate = locations[indexPath.row].coordinates

        delegate?.mapSearchVCLocationPicked(self, didSelectLocationWith: coordinate)
    }
}
